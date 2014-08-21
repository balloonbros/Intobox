require 'spec_helper'

describe TransferHistoriesController do
  let(:login) { true }

  before do
    user = User.entry_by_facebook_for_test
    controller.send(:login, user.id) if login
  end

  describe '送信履歴' do
    before do
      get :send_to
    end

    context 'ログインしていない(Facebook認証が済んでいない)場合' do
      let(:login) { false }

      it 'トップページへリダイレクトされる' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしている(Facebook認証が済んでいる)場合' do
      it '送信履歴が表示される' do
        expect(response).to render_template('send_to')
      end
    end
  end

  describe '受信履歴' do
    before do
      get :receive
    end

    context 'ログインしていない(Facebook認証が済んでいない)場合' do
      let(:login) { false }

      it 'トップページへリダイレクトされる' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしている(Facebook認証が済んでいる)場合' do
      it '受信履歴が表示される' do
        expect(response).to render_template('receive')
      end
    end
  end
end
