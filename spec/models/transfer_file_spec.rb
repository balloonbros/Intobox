require 'spec_helper'

describe TransferFile do
  describe 'ファイルを送信する' do
    let(:upload_file_ext) { 'txt' }
    let(:sender_id)       { User.entry_by_facebook_for_test.id }
    let(:receiver_id)     { User.entry_by_facebook_for_test(:sebastian).tap{|u| u.authenticate_with_dropbox_for_test('free_space') }.id }
    let(:upload_file)     {
      extend ActionDispatch::TestProcess
      fixture_file_upload("files/uploaded_file.#{upload_file_ext}", 'text/plain')
    }

    before do
      params = {
        sender_id: sender_id,
        receiver_id: receiver_id,
        upload_file: upload_file
      }
      @transferer = TransferFile.new(params)
      @result = @transferer.transfer
    end

    it '正常にファイル送信ができること' do
      expect(@result).to be_true
    end

    it 'Dropboxストラテジがincludeされていること' do
      expect(TransferFile).to be_include(TransferStrategy::Dropbox)
    end

    context '送信者と受信者が友達ではない場合' do
      let(:receiver_id) { 9999 }

      it 'ファイルを送信できない' do
        expect(@result).to be_false
      end

      it 'バリデーションエラーがあること' do
        expect(@transferer).to have(1).errors_on(:receiver_id)
      end
    end

    context '送れないファイルを送ろうとした場合' do
      let(:upload_file_ext) { 'exe' }

      it 'ファイルを送信できない' do
        expect(@result).to be_false
      end

      it 'バリデーションエラーがあること' do
        expect(@transferer).to have(1).errors_on(:upload_file)
      end
    end
  end
end
