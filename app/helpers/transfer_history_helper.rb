module TransferHistoryHelper
  def history_record_class(history)
    if history.state == Settings.database.transfer_histories.state.sending
      class_name = 'in-progress'
    elsif history.state == Settings.database.transfer_histories.state.error
      class_name = 'failed'
    else
      class_name = 'success'
    end

    return class_name
  end

  def history_result_for_sender(history)
    if history.state == Settings.database.transfer_histories.state.sending
      result = '送信先で受信中：'
    elsif history.state == Settings.database.transfer_histories.state.error
      result = '送信先で受信失敗：'
    else
      result = '完了：'
    end

    return result
  end

  def history_result_for_receiver(history)
    if history.state == Settings.database.transfer_histories.state.sending
      result = '受信中：'
    elsif history.state == Settings.database.transfer_histories.state.error
      result = '受信失敗：'
    else
      result = ''
    end

    return result
  end
end
