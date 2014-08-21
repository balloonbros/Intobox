require 'spec_helper'

describe User do
  let(:authenticated_with_dropbox)    { true }
  let(:have_send_transfer_history)    { true }
  let(:have_receive_transfer_history) { true }

  describe '退会する' do
    before do
      @user = User.entry_by_facebook_for_test
      @user.authenticate_with_dropbox_for_test if authenticated_with_dropbox
      FactoryGirl.create(:transfer_history, :success, send_user_id: @user.id) if have_send_transfer_history
      FactoryGirl.create(:transfer_history, :success, receive_user_id: @user.id) if have_receive_transfer_history

      @user.withdrawal!
    end

    shared_examples_for '関連する全てのデータが削除されていること' do
      it('Facebook認証情報が削除されている') { expect(@user.facebook_authenticate).to be_nil }
      it('Dropbox認証情報が削除されている')  { expect(@user.dropbox_authenticate).to be_nil }
      it('送信履歴が削除されている')         { expect(@user.send_transfer_histories).to be_empty }
      it('受信履歴が削除されている')         { expect(@user.receive_transfer_histories).to be_empty }
      it('ユーザー情報が論理削除されている') { expect(@user).to be_deleted }
    end

    it_should_behave_like '関連する全てのデータが削除されていること'

    context 'Dropbox認証が完了していないユーザーの場合' do
      let(:authenticated_with_dropbox) { false }

      it_should_behave_like '関連する全てのデータが削除されていること'
    end

    context '送信履歴がないユーザーの場合' do
      let(:have_send_transfer_history) { false }

      it_should_behave_like '関連する全てのデータが削除されていること'
    end

    context '受信履歴がないユーザーの場合' do
      let(:have_receive_transfer_history) { true }

      it_should_behave_like '関連する全てのデータが削除されていること'
    end
  end
end
