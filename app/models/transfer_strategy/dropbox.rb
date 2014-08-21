require 'dropbox_sdk'

module TransferStrategy::Dropbox
  def self.included(klass)
    klass.validate :authenticate_with_dropbox
    klass.validate :dropbox_free_space
  end

  def start_transfer
    begin
      dropbox_client.put_file("/#{upload_file.original_filename}", upload_file.tempfile)
    rescue => ex
      @transfer_error = ex.http_response.body
      logger.info @transfer_error
      return false
    end
  end

  def transfer_error
    @transfer_error
  end

  private

  def dropbox_client
    @dropbox_client ||= DropboxClient.new(receiver.dropbox_authenticate.access_token)
  end

  #
  # 送信先の相手がDropbox認証が完了しているかどうかをチェックします。
  #
  def authenticate_with_dropbox
    if receiver && !receiver.authenticate_with_dropbox?
      errors.add(:receiver_id, I18n.t('activemodel.errors.messages.dropbox_authenticate_error', name: receiver.facebook_authenticate.facebook_name))
    end
  end

  #
  # 送信先Dropboxに空き容量があるかどうかをチェックします。
  #
  def dropbox_free_space
    if receiver && receiver.authenticate_with_dropbox?
      quota_info = dropbox_client.account_info['quota_info']

      if quota_info['quota'] < quota_info['shared'] + quota_info['normal']
        errors.add(:receiver_id, I18n.t('activemodel.errors.messages.fill_space'))
      end
    end
  end
end
