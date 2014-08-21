class User < ActiveRecord::Base
  has_one :dropbox_authenticate
  has_one :facebook_authenticate

  has_many :send_transfer_histories,    -> { where 'receive_user_id is not null' }, class_name: 'TransferHistory', foreign_key: 'send_user_id'
  has_many :receive_transfer_histories, -> { where 'receive_user_id is not null' }, class_name: 'TransferHistory', foreign_key: 'receive_user_id'
  has_many :facebook_friends

  default_scope { where(deleted: 0) }

  scope :invalid, -> { where(deleted: 1) }

  def build_transfer_file(params)
    transfer_file = TransferFile.new(params)
    transfer_file.sender_id = id
    transfer_file
  end

  #
  # Facebook認証をして新しくユーザーを作ります。
  # 既にFacebook認証が済んでいる場合はアクセストークンを更新します。
  #
  # [引数]
  #   access_token Facebookアクセストークン
  #   ip           ユーザーのIPアドレス
  #
  # [戻り値]
  #   ユーザー情報
  #
  def self.entry_by_facebook(access_token, ip)
    # Facebookからユーザー情報を取得
    me = FbGraph::User.me(access_token).fetch

    if facebook_auth = FacebookAuthenticate.where(facebook_id: me.identifier).first
      # 既に認証済みの場合はアクセストークンとメールアドレスを更新
      facebook_auth.update_attributes(access_token: access_token, facebook_email: me.email)
      user = facebook_auth.user
    else
      # まだ認証が済んでいない場合はユーザー情報を新しく作る
      user = User.create(
        state: Settings.database.users.state.valid,
        ip: ip,
        deleted: 0
      )

      # Facebook認証情報を作る
      user.build_facebook_authenticate(
        facebook_id: me.identifier,
        access_token: access_token,
        facebook_name: me.name,
        facebook_email: me.email
      ).save
    end

    # 友達リストの自分のユーザーIDを更新する
    update_params = { friend_user_id: user.id, facebook_authenticate_id: user.facebook_authenticate.id }
    FacebookFriend.where(facebook_id: me.identifier).update_all(update_params)

    # 自分の友達リストを構築する
    user.rebuild_friend_list
    user
  end

  #
  # このユーザーでDropbox認証を行います。
  # 既にDropbox認証が済んでいる場合はアクセストークンを更新します。
  #
  # [引数]
  #   access_token Facebookアクセストークン
  #   ip           ユーザーのIPアドレス
  #
  def authenticate_with_dropbox(access_token, dropbox_id)
    dropbox_auth = DropboxAuthenticate.where(user_id: id, dropbox_id: dropbox_id).first

    if dropbox_auth
      # 既に認証済みの場合はアクセストークンを更新
      dropbox_auth.update_attribute(:access_token, access_token)
    else
      require 'dropbox_sdk'
      client = DropboxClient.new(access_token)

      # 未認証の場合は新しくDropbox認証情報を作る
      account_info = client.account_info
      DropboxAuthenticate.create(
        user_id: id,
        dropbox_id: dropbox_id,
        access_token: access_token,
        dropbox_name: account_info['display_name'],
        country: account_info['country']
      )
    end
  end

  #
  # Intoboxを退会する。
  # Facebook、Dropboxの認証情報を削除して、送受信履歴も削除します。
  #
  # [引数]
  #   delete_reason_type 退会理由(コンボボックス)
  #   delete_reason      退会理由(テキストエリア)
  #
  def withdrawal!(delete_reason_type = nil, delete_reason = nil)
    facebook_authenticate.destroy
    dropbox_authenticate.destroy if dropbox_authenticate
    send_transfer_histories.destroy_all
    receive_transfer_histories.destroy_all

    update_attributes(
      deleted: 1,
      delete_reason_type: delete_reason_type,
      delete_reason: delete_reason
    )

    reload
  end

  #
  # このユーザーがDropbox認証を済ませているかどうかをチェックします。
  #
  # [戻り値]
  #   Dropbox認証を済ませていればtrue
  #
  def authenticate_with_dropbox?
    !dropbox_authenticate.nil?
  end

  #
  # このユーザーが指定されたユーザーとFacebook上で友逹かどうかをチェックします。
  #
  # [引数]
  #   user_id 友逹かどうかをチェックするユーザーID
  #
  # [戻り値]
  #   指定されたユーザーIDがFacebook上で友逹であればtrue
  #
  def has_facebook_friend?(user_id)
    facebook_friends.where(friend_user_id: user_id).present?
  end

  #
  # このユーザーが削除されている(退会済み)かどうかをチェックします。
  #
  # [戻り値]
  #   削除されたユーザーであればtrue
  #
  def deleted?
    deleted == 1
  end

  #
  # 友逹一覧の中にファイルを送れる友逹がいるかどうかをチェックします。
  #
  # [戻り値]
  #   ファイルを送れる友逹が1人でもいればtrue
  #
  def has_sendable_friends?
    facebook_friends.select(&:sendable?).present?
  end

  #
  # このユーザーのDBの友達一覧をFacebookから取得した情報を元に再構築します。
  #
  def rebuild_friend_list
    # APIとDBから友達一覧を取得する
    friends_from_facebook = FbGraph::User.me(facebook_authenticate.access_token).fetch.friends
    friends_from_database = facebook_friends

    # 処理しやすいようにIDをキーとしたハッシュに変換する
    friends_from_facebook = friends_from_facebook.inject({}){|result, friend| result[friend.identifier]  = friend; result }
    friends_from_database = friends_from_database.inject({}){|result, friend| result[friend.facebook_id] = friend; result }

    # DBにあるけどAPIにない友達をDBから削除する
    friends_from_database.each do |id, friend|
      friend.delete if friends_from_facebook[id].blank?
    end

    # APIにあるけどDBにない友達をDBに追加する
    friends_from_facebook.each do |friend_facebook_id, friend|
      if friends_from_database[friend_facebook_id].blank?
        authenticate = FacebookAuthenticate.where(facebook_id: friend_facebook_id).first
        FacebookFriend.create(
          user_id: id,
          friend_user_id: authenticate ? authenticate.user_id : nil,
          facebook_authenticate_id: authenticate ? authenticate.id : nil,
          facebook_id: friend_facebook_id,
          facebook_name: friend.name
        )
      end
    end
  end
end
