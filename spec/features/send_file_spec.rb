require 'spec_helper'

describe 'ファイルを送信する', js: true do
  before do
    @sebastian = User.entry_by_facebook_for_test(:sebastian)
    @sebastian.authenticate_with_dropbox_for_test
    prepare_user_to_use_intobox
  end

  describe 'ファイルを送信したい友逹をクリックする' do
    before do
      sleep 0.1
      find('.js-sendable').click
    end

    it 'ファイル送信ダイアログが表示されること' do
      expect(page).to have_selector('#send-file-dialog', visible: true)
    end

    it 'ファイル送信ダイアログの中身に送信先の友逹名が表示されていること' do
      expect(page).to have_selector('#receiver-name',  text: @sebastian.stub_facebook_user['name'])
    end

    it 'ファイル送信ダイアログの中身が初期状態になっていること' do
      expect(page).to have_selector('#drop-area', text: 'ここにファイルをドロップ')
    end

    describe '送信ファイルを選択する' do
      before do
        attach_file 'upload_file', Rails.root.join("spec/fixtures/files/uploaded_file.#{upload_file_ext}"), visible: false
      end

      context '送信可能な拡張子の場合' do
        let(:upload_file_ext) { 'txt' }

        it '選択されたファイル名が画面に表示されること' do
          expect(page).to have_selector('#send-file-name', text: "uploaded_file.#{upload_file_ext}")
        end

        it '送信先の友逹名が表示されていること' do
          expect(page).to have_selector('#receiver-name2',  text: @sebastian.stub_facebook_user['name'])
        end
      end

      context 'ブラックリストに登録されている拡張子の場合' do
        let(:upload_file_ext) { 'exe' }

        it 'ファイル送信ができないこと' do
          expect(page).to have_selector('#send-file-name', text: "#{upload_file_ext}ファイルは送信できません")
        end
      end
    end
  end

  it 'ファイル送信ダイアログが非表示であること' do
    expect(page).to have_selector('#send-file-dialog', visible: false)
  end
end
