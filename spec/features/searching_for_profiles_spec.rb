require 'spec_helper'

describe 'search for profile' do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Horstine') }

  it 'displays profiles that are a partial match' do
    visit root_path
    fill_in 'search-field', with: 'Horstin'
    click_button 'Suche'
    expect(page).to have_content('Horstine')
  end
end
