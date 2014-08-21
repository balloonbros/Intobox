require 'spec_helper'

describe WelcomeController do
  describe 'トップ画面' do
    before do
      controller.send(:login, FactoryGirl.create(:user).id) if login
      get :index
    end

    context 'ログインしている場合' do
      let(:login) { true }

      it 'ホーム画面へリダイレクトすること' do
        expect(response).to redirect_to(home_path)
      end
    end

    context 'ログインしていない場合' do
      let(:login) { false }

      it 'トップ画面が描画されていること' do
        expect(response).to render_template('index')
      end
    end
  end
end
