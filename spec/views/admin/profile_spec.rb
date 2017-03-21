include AuthHelper

describe 'admin navigation' do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }
  let!(:admin_medialink) { FactoryGirl.create(:medialink, profile_id: admin.id) }
  let!(:ada) { Profile.create!(FactoryGirl.attributes_for(:published,
                    firstname: 'Ada',
                    lastname: 'Lovelace',
                    email: 'ada@lovelace.de',
                    twitter: '@alove',
                    translations_attributes:
                      {
                      '0':
                        { 'locale':       'de',
                          'main_topic':   'erstes Computer Programm',
                          'bio':          'erste Programmiererin' },
                      '1':
                        { 'locale':       'en',
                          'main_topic':   'first computer program',
                          'bio':          'first female programer' }
                        },
                    city: 'London',
                    languages: 'english, french',
                    topic_list: 'algorithm, mathematic')
                      )
                    }

  let!(:marie) { Profile.create!(FactoryGirl.attributes_for(:unpublished,
                    firstname: 'Marie' )) }

  let!(:rosa) { Profile.create!(FactoryGirl.attributes_for(:unconfirmed,
                    firstname: 'Rosa' )) }

  let!(:ada_medialink) { FactoryGirl.create(:medialink,
                                  profile_id: ada.id,
                                  title: 'Ada and the computer',
                                   url: 'www.adalovelace.de',
                                   description: 'How to programm')}

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
      expect(page).to have_content('english')
      expect(page).to have_content('french')
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
