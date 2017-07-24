include AuthHelper

describe 'profile navigation' do
  let!(:ada) { Profile.create!(FactoryGirl.attributes_for(:published,
                                                          firstname: 'Ada',
                                                          lastname: 'Lovelace',
                                                          email: 'ada@lovelace.de',
                                                          twitter: '@alove',
                                                          main_topic: 'first computer programm',
                                                          bio: 'first programmer',
                                                          city: 'London',
                                                          country: 'GB',
                                                          iso_languages: ['en', 'fr'],
                                                          topic_list: 'algorithm, mathematic'
                                                                    )) }
  let!(:ada_medialink) { FactoryGirl.create(:medialink, profile_id: ada.id,
                                                        title: 'Ada and the computer',
                                                        url: 'www.adalovelace.de',
                                                        description: 'How to programm')}

  describe 'show view profile in EN' do
    before do
      sign_in ada
      click_on 'EN', match: :first
    end

    it 'directs after signin to the own profile page' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('@alove')
      expect(page).to have_content('London')
      expect(page).to have_content('United Kingdom')
      expect(page).to have_content('first programmer')
      expect(page).to have_content('first computer programm')
      expect(page).to have_content('algorithm')
      expect(page).to have_content('mathematic')
      expect(page).to have_content('English')
      expect(page).to have_content('French')
      expect(page).to have_content('Ada and the computer')
      expect(page).to have_content('www.adalovelace.de')
      expect(page).to have_content('How to programm')
    end

    it 'gives the possibility to edit the account information' do
      expect(page).to have_css('#accountSettings')
    end
  end
  describe 'show view profile in DE' do
    before do
      sign_in ada
      click_on 'EN', match: :first
      click_on 'DE', match: :first
    end

    it 'directs after signin to the own profile page' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('@alove')
      expect(page).to have_content('London')
      expect(page).to have_content('Vereinigtes Königreich')
      expect(page).to have_content('first programmer')
      expect(page).to have_content('first computer programm')
      expect(page).to have_content('algorithm')
      expect(page).to have_content('mathematic')
      expect(page).to have_content('Englisch')
      expect(page).to have_content('Französisch')
      expect(page).to have_content('Ada and the computer')
      expect(page).to have_content('www.adalovelace.de')
      expect(page).to have_content('How to programm')
    end

    it 'gives the possibility to edit the account information' do
      expect(page).to have_css('#accountSettings')
    end
  end

  describe 'edit view profile in EN' do
    before do
      sign_in ada
      click_on 'EN', match: :first
      click_on 'Edit profile'
    end

    it 'directs after edit profile to the edit page' do
      expect(page).to have_content('name')
      expect(page).to have_content('twitteraccount')
      expect(page).to have_content('My main topic in German')
    end

    it 'shows the correct tabs and the selected tab' do
      expect(page).to have_css('.selected', text: 'English')
    end

    it 'shows the correct main topic' do
      expect(page).to have_css('.hidden', text: 'My main topic in German')
    end
  end

  describe 'edit view profile in DE' do
    before do
      sign_in ada
      click_on 'EN', match: :first
      click_on 'DE', match: :first
      click_on 'Profil bearbeiten'
    end

    it 'directs after edit profile to the edit page' do
      expect(page).to have_content('Vorname')
      expect(page).to have_content('Twitteraccount')
      expect(page).to have_content('Mein Hauptthema auf Deutsch:')
    end

    it 'shows the correct tabs and the selected tab' do
      expect(page).to have_css('.selected', text: 'Deutsch')
    end

    it 'shows the correct main topic' do
      expect(page).to have_css('.hidden', text: 'Mein Hauptthema auf Englisch')
    end
  end
end
