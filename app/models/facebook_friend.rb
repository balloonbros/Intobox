class FacebookFriend < ActiveRecord::Base
  belongs_to :facebook_authenticate
  belongs_to :user
  belongs_to :friend_user, class_name: 'User'

  scope :intobox_user, -> { where('friend_user_id IS NOT NULL') }

  #
  # このFacebook友逹がIntoboxにアカウントを持っているかどうかをチェックします。
  #
  # [戻り値]
  #   Intoboxにアカウントを持っていればtrue
  #
  def has_intobox_account?
    friend_user_id.present?
  end

  #
  # このFacebook友達がDropbox認証を完了しているかどうかをチェックします。
  #
  # [戻り値]
  #   Dropbox認証が完了していればtrue
  #
  def authenticate_with_dropbox?
    has_intobox_account? && friend_user.authenticate_with_dropbox?
  end
  alias_method :sendable?, :authenticate_with_dropbox?

  #
  # このFacebook友逹をIntoboxへ誘うための招待用URLを取得します。
  #
  # [戻り値]
  #   Intoboxへ誘うためのsend dialogのURL
  #
  def invitation_url
    url  = "https://www.facebook.com/dialog/send?app_id=#{Rails.application.secrets.oauth.facebook.app}"
    url += "&name=#{Settings.service.facebook_application_name}"
    url += "&redirect_uri=#{Settings.facebook.invitation.redirect_uri}?name=#{facebook_name}"
    url += "&link=#{Settings.facebook.invitation.link}#{Rails.application.routes.url_helpers.root_path}"
    url += "&to=#{facebook_id}"
    url += "&description=intobox始めてみませんか？"
    return url
  end
end
