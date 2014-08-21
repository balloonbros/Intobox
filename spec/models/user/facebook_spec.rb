require 'spec_helper'

describe User do
  let(:friend_count) { 10 }

  before do
    @user = User.entry_by_facebook_for_test.reload
  end

  describe 'ユーザーの友達リストを再構築する' do
    before do
      @user.rebuild_friend_list
    end

    it '友達リストが構築されていること' do
      friend = @user.reload.facebook_friends.first
      expect(friend.user_id).to eq @user.id
      expect(friend.friend_user_id).to be_nil
      expect(friend.facebook_authenticate_id).to be_nil
      expect(friend.facebook_name).to eq @user.stub_facebook_friends['data'].first['name']
    end

    describe '友達の増減' do
      before do
        facebook_authenticate = @user.facebook_authenticate
        @friends_json = stub_request_for_facebook_friends_by_user_id(facebook_authenticate.facebook_id, friends_mock, facebook_authenticate.access_token)
        @user.rebuild_friend_list
        @user.reload
      end

      context '友達が1人増えた場合' do
        let(:friends_mock) { :me_four_friends }

        it '友達の人数が正しいこと' do
          expect(@user.facebook_friends).to have(@friends_json['data'].length).items
        end
      end

      context '友達が1人減った場合' do
        let(:friends_mock) { :me_two_friends }

        it '友達の人数が正しいこと' do
          expect(@user.facebook_friends).to have(@friends_json['data'].length).items
        end
      end
    end
  end

  describe 'ユーザーがあるユーザーとFacebook上で友逹かどうかのチェック' do
    context 'Facebook上の友逹ではない場合' do
      it '友逹と判断されないこと' do
        expect(@user).not_to have_facebook_friend(999)
      end
    end

    context 'Facebook上の友逹の場合' do
      it '友逹と判断されること' do
        expect(@user).to have_facebook_friend(@user.facebook_friends.first.friend_user_id)
      end
    end
  end

  describe 'Facebook上の友達にファイルを送れる友達がいるかどうかをチェックする' do
    context 'ファイルを送れる友達がいる場合' do
      before do
        User.entry_by_facebook_for_test(:sebastian).authenticate_with_dropbox_for_test
        # facebook_authenticate = FactoryGirl.create(:facebook_authenticate)
        # facebook_authenticate.user.authenticate_with_dropbox_for_test
        # @user.facebook_friends.first.update_attributes(
        #   friend_user_id: facebook_authenticate.user.id,
        #   facebook_authenticate_id: facebook_authenticate.id
        # )
      end

      it 'ファイルを送れる' do
        expect(@user).to have_sendable_friends
      end
    end

    context 'ファイルを送れる友達がいない場合' do
      it 'ファイルを送れない' do
        expect(@user).not_to have_sendable_friends
      end
    end
  end
end
