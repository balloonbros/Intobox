class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  # ステージングのみBASIC認証をかける
  before_filter :authenticate_with_basic if Rails.env.staging?

  # 例外発生時は500エラー
  rescue_from Exception, :with => :render_500 if Rails.env.production?

  #
  # 例外発生時の処理
  # ログを取ってエラーページを表示する
  #
  # [引数]
  #   e 例外
  #
  def render_500(e = nil)
    if e
      logger.fatal e.message
      logger.fatal e.backtrace.join("\n")
    end

    ExceptionNotifier::Notifier.exception_notification(request.env, e).deliver
    render file: Rails.root.join('public/500.html'), status: 500, content_type: 'text/html'
  end

  #
  # ルーティングエラー時の処理
  #
  # [引数]
  #   e 例外
  #
  def render_404(e = nil)
    render file: Rails.root.join('public/404.html'), status: 404, content_type: 'text/html'
  end

  private

  #
  # BASIC認証をかける。
  #
  def authenticate_with_basic
    authenticate_or_request_with_http_basic('ステージング環境のIDとパスワード入れて') do |username, password|
      username == Rails.application.secrets.staging.username && password == Rails.application.secrets.staging.password
    end
  end

  #
  # HTTPSプロトコルでリダイレクトします。
  # 開発環境とテスト環境は通常通りHTTPでリダイレクトします。
  #
  # [引数]
  #   path リダイレクト先
  #
  def redirect_to_secure(path)
    if Rails.env.test?
      redirect_to path
    else
      redirect_to "https://#{Settings.service.host_name}#{path}"
    end
  end

  #
  # ログインしているかどうかをチェックしてしていなければ
  # トップページへリダイレクトします。
  #
  def redirect_root_unless_login
    redirect_to_secure root_path unless logged_in?
  end

  #
  # ログインしているかどうかをチェックします。
  #
  # [戻り値]
  #   ログインしていればtrue。
  #
  def logged_in?
    return session.key?(:login_user_id) && !session[:login_user_id].nil?
  end

  #
  # 指定したユーザーIDでログイン状態にします。
  #
  # [引数]
  #   user_id このユーザーIDのユーザーでログイン状態にします。
  #
  def login(user_id)
    session[:login_user_id] = user_id
  end

  #
  # ログアウトします。
  #
  def logout
    session[:login_user_id] = nil
  end

  #
  # 現在ログイン中のユーザーを取得します。
  #
  # [戻り値]
  #   現在ログイン中のユーザー情報。
  #   ログインしていない場合はnilを返します。
  #
  def current_user
    if !logged_in?
      return nil
    else
      return User.find(session[:login_user_id])
    end
  end
end
