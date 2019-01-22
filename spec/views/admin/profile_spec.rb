# frozen_string_literal: true

describe 'admin navigation' do
  include AuthHelper

  let!(:admin) { FactoryBot.create(:admin) }
  let!(:admin_medialink) { FactoryBot.create(:medialink, profile_id: admin.id) }

  let!(:ada) { create(:ada, topic_list: 'algorithm') }

  let!(:marie) { FactoryBot.create(:unpublished_profile, firstname: 'Marie') }
  let!(:rosa) { FactoryBot.create(:unconfirmed_profile, firstname: 'Rosa') }

  let!(:ada_medialink) do
    FactoryBot.create(:medialink,
                      profile_id: ada.id,
                      title: 'Ada and the computer',
                      url: 'www.adalovelace.de',
                      description: 'How to programm')
  end

  describe 'in profile' do
    before do
      sign_in admin
      click_on 'Admin'
      click_on 'EN', match: :first
      click_on 'Profiles'
    end

    it 'show single profile with the correct content' do
      click_on 'Ada Lovelace'

      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('@alove')
      expect(page).to have_content('London')
      expect(page).to have_content('She published the first algorithm for a machine.')
      expect(page).to have_content('math')
      expect(page).to have_content('algorithm')
      expect(page).to have_content('English')
      expect(page).to have_content('German')
      expect(page).to have_link('Ada and the computer', href: 'www.adalovelace.de')
      expect(page).to have_content('How to programm')
    end
  end

  describe 'all profiles' do
    before do
      sign_in admin
      click_on 'Admin'
      click_on 'EN', match: :first
      click_on 'Profiles'
    end

    it 'shows published and unpublished but not the unconfirmed profiles' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Marie')
      expect(page).not_to have_content('Rosa')
    end
  end
end
