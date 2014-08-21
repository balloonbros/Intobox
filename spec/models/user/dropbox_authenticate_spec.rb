require 'spec_helper'

describe User do
  describe 'Dropbox認証をする' do
    let(:dropbox_id) { (0..9).to_a.sample(5).join }
    let(:access_token) { random_access_token }

    before do
      stub_request_for_dropbox_account

      @user = FactoryGirl.create(:user)
      @user.authenticate_with_dropbox(access_token, dropbox_id)
    end

    context '初めて認証する場合' do
      before do
        @dropbox = @user.dropbox_authenticate
      end

      it 'Dropbox認証データができている' do
        expect(@user).to be_authenticate_with_dropbox

        expect(@dropbox.access_token).to eq(access_token)
        expect(@dropbox.dropbox_id)  .to eq(dropbox_id)
      end
    end

    context '既に認証済みの場合' do
      let(:new_access_token) { random_access_token }

      before do
        @user.authenticate_with_dropbox(new_access_token, dropbox_id)
        @dropbox = @user.dropbox_authenticate
      end

      it 'Dropbox認証データのアクセストークンが更新されている' do
        expect(@dropbox.access_token).to eq(new_access_token)
      end
    end
  end
end
