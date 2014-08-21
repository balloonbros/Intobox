class AdminMessage < ActionMailer::Base
  # デフォルトでの送信元のアドレス
  default from: Settings.notify.from

  def withdrawal(params, facebook_name)
    @params = params
    @facebook_name = facebook_name
    mail(to: Settings.notify.to.withdrawal, subject: "#{@facebook_name}さんがIntoboxから退会しました。")
  end
end
