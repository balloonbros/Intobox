require 'spec_helper'

describe TransfersController do
  describe 'Dropboxへファイル送信' do
    let(:logged_in)   { true }
    let(:sender_id)   { User.entry_by_facebook_for_test.id }
    let(:receiver_id) { User.entry_by_facebook_for_test(:sebastian).tap{|u| u.authenticate_with_dropbox_for_test}.id }
    let(:upload_file) { fixture_file_upload('files/uploaded_file.txt', 'text/plain') }

    before do
      controller.send(:login, sender_id) if logged_in

      post :create, transfer: { receiver_id: receiver_id, upload_file: upload_file }
      @body = JSON.parse(response.body)
    end

    it '処理に成功していること' do
      expect(@body['success']).to be_true
    end

    it 'エラーがないこと' do
      expect(@body['error']).to be_nil
    end

    shared_examples_for 'ファイル送信に失敗すること' do
      it '処理に失敗していること' do
        expect(@body['success']).to be_false
      end

      it 'エラーがあること' do
        expect(@body['error']).not_to be_empty
      end
    end

    context 'ログインしていない場合' do
      let(:logged_in) { false }

      it_behaves_like 'ファイル送信に失敗すること'
    end

    context 'パラメータが渡ってこない場合' do
      let(:receiver_id) { nil }
      let(:upload_file) { nil }

      it_behaves_like 'ファイル送信に失敗すること'
    end
  end
end
