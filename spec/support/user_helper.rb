User.class_eval do
  #
  # スタブで生成されたデータにアクセスできるように
  #
  # Facebookの自分のユーザー情報 / Facebookの自分の友逹一覧 / Facebookのアクセストークン
  attr_accessor :stub_facebook_user, :stub_facebook_friends, :stub_facebook_access_token

  #
  # テスト用にDropbox認証を完了したことにします。
  # DropboxのIDとアクセストークンはランダムな値になります。
  #
  def authenticate_with_dropbox_for_test(disk_space = :free_space)
    stub_request_for_dropbox_account(disk_space)

    access_token = "access_token_for_dropbox#{(0..9).to_a.sample(5).join}"
    dropbox_id   = (0..9).to_a.sample(5).join
    authenticate_with_dropbox(access_token, dropbox_id)
  end

  #
  # テスト用にFacebook認証を完了したユーザーを作成します。
  # 自分の情報及び友逹一覧は mocks/fb_graph/{users,friends} 以下の
  # JSONデータでモックします。
  #
  # [引数]
  #   user         Facebookのユーザー。シンボルで指定します。
  #                デフォルトは :me (自分自身) です。
  #   access_token Facebookのアクセストークン。デフォルトはnilで
  #                nilの場合はランダムなアクセストークンが自動的に設定されます。
  #
  # [戻り値]
  #   Facebook認証が完了しているユーザー
  #
  def self.entry_by_facebook_for_test(user = :me, access_token = nil)
    access_token ||= random_access_token
    stub_facebook_user = stub_request_for_facebook_user(user, access_token)
    stub_facebook_friends = stub_request_for_facebook_friends(user, access_token)

    user = User.entry_by_facebook(access_token, '127.0.0.1')

    user.stub_facebook_access_token = access_token
    user.stub_facebook_user = stub_facebook_user
    user.stub_facebook_friends = stub_facebook_friends

    user
  end
end
