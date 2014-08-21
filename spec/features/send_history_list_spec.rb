require 'spec_helper'

describe '送信履歴一覧', js: true do
  let(:have_history) { true }

  before do
    sender = prepare_user_to_use_intobox
    receiver = User.entry_by_facebook_for_test(:sebastian)

    @history = FactoryGirl.create(:transfer_history, receive_user_id: receiver.id, send_user_id: sender.id) if have_history
    visit send_transfer_histories_path
  end

  it '履歴一覧が表示されていること' do
    expect(page).to have_text(@history.filename)
  end

  context 'まだ履歴がない場合' do
    let(:have_history) { false }

    it '履歴がないという文言が表示されていること' do
      expect(page).to have_text('まだ履歴はありません。')
    end
  end
end
