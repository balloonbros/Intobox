require 'spec_helper'

describe User do
  describe 'Facebook認証をする' do
    before do
      @me = User.entry_by_facebook_for_test
      @facebook = @me.facebook_authenticate
    end

    it 'Facebook認証データが出来ている' do
      expect(@facebook.access_token).to   eq(@me.stub_facebook_access_token)
      expect(@facebook.facebook_id).to    eq(@me.stub_facebook_user['id'])
      expect(@facebook.facebook_name).to  eq(@me.stub_facebook_user['name'])
      expect(@facebook.facebook_email).to eq(@me.stub_facebook_user['email'])
    end

    it '友達リストが出来ている' do
      @me.reload
      expect(@me.facebook_friends).to have(@me.stub_facebook_friends['data'].length).items
      expect(@me.facebook_friends.intobox_user).to be_empty
    end

    context '既に自分が誰かの友達リストに入っている場合' do
      before do
        @sebastian = User.entry_by_facebook_for_test :sebastian
      end

      it '友達リストのユーザーIDが更新されている' do
        expect(@me.facebook_friends.intobox_user).to have(1).item
        expect(@sebastian.facebook_friends.intobox_user).to have(1).item
      end
    end

    context '既に認証済みで再度認証する場合' do
      before do
        @me = User.entry_by_facebook_for_test(:me_modified_email)
        @facebook = @me.facebook_authenticate
      end

      it 'Facebook認証データのアクセストークンとメールアドレスが更新されている' do
        expect(@facebook.access_token).to   eq(@me.stub_facebook_access_token)
        expect(@facebook.facebook_email).to eq(@me.stub_facebook_user['email'])
      end
    end
  end
end
