include AuthHelper

describe 'profile navigation' do
  let!(:ada) do
    Profile.create!(FactoryGirl.attributes_for(:published, firstname: 'Ada',
                                                           lastname: 'Lovelace',
                                                           email: 'ada@lovelace.de',
                                                           twitter: '@alove',
                                                           main_topic: 'first computer programm',
                                                           bio: 'first programmer',
                                                           city: 'London',
                                                           languages: 'english, french',
                                                           topic_list: 'algorithm, mathematic'))
  end
  let!(:ada_medialink) do
    FactoryGirl.create(:medialink, profile_id: ada.id, title: 'Ada and the computer',
                                                       url: 'www.adalovelace.de',
                                                       description: 'How to programm')
  end

  describe 'show view profile' do
    before do
      sign_in ada
      click_on 'EN', match: :first
    end

    it 'directs after signin to the own profile page' do
      expect(page).to have_content('Ada')
      expect(page).to have_content('Lovelace')
      expect(page).to have_content('@alove')
      expect(page).to have_content('London')
      expect(page).to have_content('first programmer')
      expect(page).to have_content('first computer programm')
      expect(page).to have_content('algorithm')
      expect(page).to have_content('mathematic')
      expect(page).to have_content('english')
      expect(page).to have_content('french')
      expect(page).to have_content('Ada and the computer')
      expect(page).to have_content('www.adalovelace.de')
      expect(page).to have_content('How to programm')
    end
  end
end
