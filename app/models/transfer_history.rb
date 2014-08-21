class TransferHistory < ActiveRecord::Base
  belongs_to :send_user,    class_name: 'User', foreign_key: 'send_user_id'
  belongs_to :receive_user, class_name: 'User', foreign_key: 'receive_user_id'

  #
  # 送受信履歴を登録します。
  #
  # [引数]
  #   send_user_id    ファイル送信元ユーザーID
  #   receive_user_id ファイル送信先ユーザーID
  #   file_name       送信ファイル名
  #   file_size       送信ファイルサイズ
  #
  # [戻り値]
  #   登録された送受信履歴
  #
  def self.register(send_user_id, receive_user_id, file_name, file_size)
    history = TransferHistory.new(
      send_user_id: send_user_id,
      receive_user_id: receive_user_id,
      state: Settings.database.transfer_histories.state.sending,
      filename: file_name,
      file_size: file_size
    )
    history.save

    return history
  end

  #
  # 送受信履歴の状態をファイル送信完了に更新します。
  #
  def complete_sending!
    self.update_attribute(:state, Settings.database.transfer_histories.state.success)
  end

  #
  # 送受信履歴の状態をエラー状態に更新します。
  #
  # [引数]
  #   body DropboxAPIからの戻り値
  #
  def send_error!(body)
    self.update_attributes(
      state: Settings.database.transfer_histories.state.error,
      api_response: body
    )
  end
end
