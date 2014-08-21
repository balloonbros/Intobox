require 'spec_helper'

describe FacebookFriend do
  let(:user)         { nil }
  let(:access_token) { random_access_token }
  let(:friend_user_id) { 1 }

  before do
    @friend = FactoryGirl.create(:facebook_friend, friend_user_id: friend_user_id)
  end

  describe 'Intoboxアカウントの保持チェック' do
    context 'Intoboxにアカウントを持っていない場合' do
      let(:friend_user_id) { nil }

      it 'has_intobox_account?メソッドがfalseを返す' do
        expect(@friend).not_to have_intobox_account
      end
    end

    context 'Intoboxにアカウントを持っている場合' do
      it 'has_intobox_account?メソッドがtrueを返す' do
        expect(@friend).to have_intobox_account
      end
    end
  end

  describe 'Dropbox認証チェック' do
    context 'Facebookの友達がDropbox認証をしている場合' do
      before do
        @friend.friend_user.authenticate_with_dropbox_for_test
      end

      it 'Dropbox認証は完了していること' do
        expect(@friend).to be_authenticate_with_dropbox
        expect(@friend).to be_sendable
      end
    end

    context 'Facebookの友達がまだDropbox認証をしていない場合' do
      it 'Dropbox認証は完了していないこと' do
        expect(@friend).not_to be_authenticate_with_dropbox
        expect(@friend).not_to be_sendable
      end
    end
  end
end
