require 'spec_helper'

describe 'トップページ', js: true do
  before do
    visit root_path
  end

  it '正常に表示されること' do
    expect(page).to have_title(I18n.t('layouts.title'))
  end
end
