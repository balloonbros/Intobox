class HomeController < ApplicationController
  before_filter :redirect_root_unless_login

  #
  # ホーム画面
  #
  def index
    # Dropbox認証が済んでいなければDropbox認証へ誘導する画面を表示する
    render 'none_auth_for_dropbox' and return unless current_user.authenticate_with_dropbox?

    # Facebookの友逹が一人もいなければ友逹を探す画面を表示する
    @facebook_friends = current_user.facebook_friends
    render 'none_facebook_friend' and return if @facebook_friends.empty?

    # 初回チュートリアルを表示していなければ表示する
    @tutorial = cookies[:intobox_tutorial].nil?
    cookies[:intobox_tutorial] = 1 unless cookies[:intobox_tutorial]

    # 友達に招待メッセージを送って戻ってきた場合は送信完了のダイアログを表示する
    @sent_message_friend_name = params[:name] if params[:success] == '1'
  end
end
