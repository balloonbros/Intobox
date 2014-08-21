require 'spec_helper'

describe TransferHistory do
  let(:sender)    { FactoryGirl.create(:user) }
  let(:receiver)  { FactoryGirl.create(:user) }
  let(:file_name) { 'test.txt' }
  let(:file_size) { 100 }

  before do
    @history = TransferHistory.register(sender.id, receiver.id, file_name, file_size)
  end

  describe 'ファイル送信履歴を登録する' do
    it 'ファイル送信履歴が登録されていること' do
      expect(@history.send_user_id).to eq sender.id
      expect(@history.receive_user_id).to eq receiver.id
      expect(@history.state).to eq Settings.database.transfer_histories.state.sending
      expect(@history.filename).to eq file_name
      expect(@history.file_size).to eq file_size
    end
  end

  describe 'ファイル送信履歴の状態を送信完了にする' do
    before do
      @history.complete_sending!
    end

    it '送信完了状態になっていること' do
      expect(@history.state).to eq Settings.database.transfer_histories.state.success
    end
  end
end
