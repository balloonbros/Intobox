class SessionController < ApplicationController
  #
  # Facebook OAuth処理
  #
  def facebook
    # Facebook認証する
    auth = request.env['omniauth.auth']
    user = User.entry_by_facebook(auth.credentials.token, request.remote_ip)

    # ログイン状態にしておく
    login(user.id)
    redirect_to_secure home_path
  end

  #
  # Dropbox OAuth処理
  #
  def dropbox_oauth2
    render 'expired_session_on_dropbox_oauth', layout: 'other' and return unless logged_in?

    auth = request.env['omniauth.auth']

    # Dropbox認証する
    current_user.authenticate_with_dropbox(auth.credentials.token, auth.uid)
    redirect_to_secure home_path
  end

  #
  # サインアウト
  #
  def signout
    logout
    redirect_to_secure root_path
  end
end
