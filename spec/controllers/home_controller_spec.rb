require 'spec_helper'

describe HomeController do
  let(:user)                      { User.entry_by_facebook_for_test }
  let(:authenticate_with_dropbox) { true }
  let(:have_cookie)               { true }
  let(:params)                    { {} }

  describe 'ホーム画面' do
    before do
      controller.send(:login, user.id) if login
      user.authenticate_with_dropbox_for_test if authenticate_with_dropbox
      request.cookies[:intobox_tutorial] = 1 if have_cookie
      get :index, params
    end

    context 'ログインしていない(Facebook認証が済んでいない)場合' do
      let(:login) { false }

      it 'トップページへリダイレクトされる' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしている(Facebook認証済み)の場合' do
      let(:login) { true }

      it '友逹一覧がビューに渡されている' do
        expect(assigns).to have_key(:facebook_friends)
      end

      context '友逹が一人もいない場合' do
        let(:user) { User.entry_by_facebook_for_test(:lonely) }

        it '友逹を探すのを促すページが表示される' do
          expect(response).to render_template('none_facebook_friend')
        end
      end

      context 'Dropbox認証がまだ済んでいない場合' do
        let(:authenticate_with_dropbox) { false }

        it 'Dropbox認証を促すページが表示される' do
          expect(response).to render_template('none_auth_for_dropbox')
        end
      end

      context 'Dropbox認証まで完了している場合' do
        let(:authenticate_with_dropbox) { true }

        it 'ホーム画面が表示される' do
          expect(response).to render_template('index')
        end
      end

      context '初回アクセスの場合' do
        let(:have_cookie) { false }

        it 'チュートリアルのダイアログボックスが表示される' do
          expect(assigns[:tutorial]).to be_true
        end

        it 'クッキーに値が入っている' do
          expect(response.cookies['intobox_tutorial']).to eq '1'
        end
      end

      context '1度でもアクセスしたことがある場合' do
        it 'チュートリアルのダイアログボックスは表示されない' do
          expect(assigns[:tutorial]).to be_false
        end
      end

      context '招待メッセージ送信画面から戻ってきた場合' do
        let(:params) { { name: 'test', success: '1' } }

        it '送信完了ダイアログボックスが表示される' do
          expect(assigns[:sent_message_friend_name]).to eq params[:name]
        end
      end
    end
  end
end
