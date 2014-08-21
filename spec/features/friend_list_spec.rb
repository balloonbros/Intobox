require 'spec_helper'

describe '友逹一覧', js: true do
  let(:have_friend) { true }

  before do
    @sebastian = User.entry_by_facebook_for_test(:sebastian) if have_friend
    @user = prepare_user_to_use_intobox(user)
  end

  context '友逹が1人以上いる場合' do
    let(:user) { :me }

    it '友逹一覧が表示されていること' do
      @user.stub_facebook_friends['data'].each do |friend|
        expect(page).to have_text(friend['name'])
      end
    end

    context 'Dropbox認証待ちの友逹がいる場合' do
      it 'Dropbox認証待ちの旨の文章が表示される' do
        expect(page).to have_text('Dropbox認証待ち')
      end
    end

    describe 'ファイルを送れる友逹一覧を表示する' do
      let(:have_sendable_friend) { true }

      before do
        @sebastian.authenticate_with_dropbox_for_test if have_sendable_friend

        visit privacy_policy_path
        visit "#{home_path}#sendable"
      end

      it 'ファイルを送れる友逹が表示されていること' do
        expect(page).to have_text(@sebastian.stub_facebook_user['name'])
        @user.stub_facebook_friends['data'].each do |friend|
          expect(page).not_to have_text(friend['name']) if friend['name'] != @sebastian.stub_facebook_user['name']
        end
      end

      context 'ファイルを送れる友逹が一人もいない場合' do
        let(:have_friend)          { false }
        let(:have_sendable_friend) { false }

        it 'ファイルを送れる人がいない旨の文章が表示される' do
          expect(page).to have_text('ファイルを送れる状態の友達がいません。')
        end
      end
    end
  end

  context '友逹が一人もいない場合' do
    let(:user) { :lonely }

    it '友逹を探しましょうページが表示されること' do
      expect(page).to have_text('Intoboxをご利用になるには、Facebookの友逹が一人以上必要です。')
    end
  end
end
