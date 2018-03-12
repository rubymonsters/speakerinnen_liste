include AuthHelper

describe 'admin navigation' do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:admin_medialink) { FactoryBot.create(:medialink, profile_id: admin.id) }

  let!(:ada) do
    FactoryBot.create(:published,
                       firstname: 'Ada',
                       lastname: 'Lovelace',
                       email: 'ada@lovelace.de',
                       twitter: '@alove',
                       main_topic_de: 'erstes Computer Programm',
                       bio_de: 'erste Programmiererin',
                       main_topic_en:   'first computer program',
                       bio_en:          'first female programer',
                       city: 'London',
                       iso_languages: %w[en fr],
                       topic_list: 'algorithm, mathematic')
  end
  let!(:marie) { FactoryBot.create(:unpublished, firstname: 'Marie') }
  let!(:rosa) { FactoryBot.create(:unconfirmed, firstname: 'Rosa') }

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
      expect(page).to have_content('erstes Computer Programm')
      expect(page).to have_content('erste Programmiererin')
      expect(page).to have_content('first female programer')
      expect(page).to have_content('first computer program')
      expect(page).to have_content('algorithm')
      expect(page).to have_content('mathematic')
      expect(page).to have_content('English')
      expect(page).to have_content('French')
      expect(page).to have_content('Ada and the computer')
      expect(page).to have_content('www.adalovelace.de')
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

    it 'shows published and unplublished but not the unconfirmed profiles' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Marie')
      expect(page).not_to have_content('Rosa')
    end
  end
end
