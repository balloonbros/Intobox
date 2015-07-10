class TransferFile
  include ActiveModel::Model

  attr_accessor :sender_id, :receiver_id, :upload_file, :send_message, :facebook_message

  validates :upload_file, presence: true
  validates :receiver_id, presence: true

  validate :facebook_friend
  validate :not_in_black_list

  def transfer
    self.class.send(:include, transfer_strategy)
    return false if invalid?

    Thread.new do
      history = TransferHistory.register(sender_id, receiver_id, upload_file.original_filename, upload_file.tempfile.size)

      if start_transfer
        history.complete_sending!
      else
        history.send_error!(transfer_error)
      end
    end

    true
  end

  private

  def transfer_strategy
    TransferStrategy::Dropbox
  end

  def sender
    @sender ||= User.where(id: sender_id).first
  end

  def receiver
    @receiver ||= User.where(id: receiver_id).first
  end

  #
  # ファイルの送信者と受信者がそれぞれFacebookで友逹かどうかをチェックします。
  #
  def facebook_friend
    if sender && !sender.has_facebook_friend?(receiver_id)
      errors.add(:receiver_id, I18n.t('activemodel.errors.messages.not_friend'))
    end
  end

  #
  # 送信ファイルの拡張子がブラックリストに含まれているかどうかをチェックします。
  #
  def not_in_black_list
    return unless upload_file

    ext = File.extname(upload_file.original_filename).sub('.', '')

    if Settings.black_list.include?(ext)
      errors.add(:upload_file, I18n.t('activemodel.errors.messages.include_black_list', ext: ext))
    end
  end
end
