class UsersController < ApplicationController
  before_filter :redirect_root_unless_login

  #
  # 退会画面
  #
  def delete
  end

  #
  # 退会処理
  #
  def destroy
    # ログイン中のユーザー以外のIDが指定されていれば何もしない
    redirect_to home_path and return if current_user.id.to_s != params[:id]

    # ユーザー退会処理
    facebook_name = current_user.facebook_authenticate.facebook_name
    current_user.withdrawal!(params[:delete_reason_type], params[:delete_reason])

    # Intoboxにメールを送る
    AdminMessage.withdrawal(params, facebook_name).deliver

    # ログアウト状態にして完了画面を表示
    logout
    render :withdrawal, layout: 'other'
  end
end
