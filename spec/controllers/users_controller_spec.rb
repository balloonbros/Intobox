require 'spec_helper'

describe UsersController do
  describe 'ユーザーの退会処理' do
    let(:user_id) { @user.id }

    before do
      @user = User.entry_by_facebook_for_test
      controller.send(:login, @user.id)

      post :destroy, id: user_id, delete_reason_type: 0, delete_reason: ''
    end

    it 'ユーザーが削除されていること' do
      expect(@user.reload).to be_deleted
    end

    it '削除完了ページが表示されていること' do
      expect(response).to render_template('withdrawal')
    end

    it 'ログアウト状態になっていること' do
      expect(controller).not_to be_logged_in
    end

    context 'ログイン中以外のユーザーIDが指定された場合' do
      let(:user_id) { 0 }

      it 'ホーム画面へリダイレクトすること' do
        expect(response).to redirect_to home_path
      end
    end
  end
end
