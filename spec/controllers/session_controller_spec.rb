require 'spec_helper'

describe SessionController do
  before do
    OmniAuth.config.test_mode = true
  end

  describe 'FacebookのOAuth認証をする' do
    let(:facebook_access_token) { random_access_token }

    before do
      stub_omniauth_for(:facebook, facebook_access_token)
      stub_request_for_facebook_user(:me, facebook_access_token)
      stub_request_for_facebook_friends(:me, facebook_access_token)

      get :facebook
    end

    it '新しくユーザーが生成されていること' do
      facebook = FacebookAuthenticate.where(access_token: facebook_access_token).first
      expect(facebook).not_to be_nil
    end

    it 'ホーム画面へリダイレクトすること' do
      expect(response).to redirect_to(home_path)
    end
  end

  describe 'DropboxのOAuth認証をする' do
    let(:dropbox_access_token) { random_access_token }
    let(:user)                 { FactoryGirl.create(:user) }

    before do
      stub_omniauth_for(:dropbox_oauth2, dropbox_access_token)
      stub_request_for_dropbox_account
      controller.send(:login, user.id) if login

      get :dropbox_oauth2
    end

    context 'ログイン状態の場合' do
      let(:login) { true }

      it 'ユーザーのDropbox認証が完了していること' do
        expect(user).to be_authenticate_with_dropbox
      end

      it 'ホーム画面へリダイレクトすること' do
        expect(response).to redirect_to(home_path)
      end
    end

    context 'ログアウトしている場合' do
      let(:login) { false }

      it 'ユーザーのDropbox認証は完了していないこと' do
        expect(user).not_to be_authenticate_with_dropbox
      end

      it 'セッション切れを警告する画面が描画されていること' do
        expect(response).to render_template('expired_session_on_dropbox_oauth')
      end
    end
  end
end
