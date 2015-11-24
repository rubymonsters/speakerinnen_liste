include AuthHelper

describe 'admin navigation' do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }
  let!(:admin_medialink) { FactoryGirl.create(:medialink, profile_id: admin.id) }
  let!(:non_admin) { Profile.create!(FactoryGirl.attributes_for(:published,
                                                                firstname: 'Ada',
                                                                lastname: 'Lovelace',
                                                                email: 'ada@lovelace.de',
                                                                twitter: '@alove',
                                                                main_topic: 'first computer programm',
                                                                bio: 'first programmer',
                                                                city: 'London',
                                                                languages: 'english, french',
                                                                topic_list: 'algorithm, mathematic'
                                                                          )) }
  let!(:non_admin_medialink) { FactoryGirl.create(:medialink, profile_id: non_admin.id,
                                                              title: 'Ada and the computer',
                                                               url: 'www.adalovelace.de',
                                                               description: 'How to programm')}

  describe 'show view profile' do
    before do
      sign_in admin
      click_on 'Admin'
      click_on 'EN', match: :first
      click_on 'Profiles'
      click_on 'Ada Lovelace'
    end

    it 'with the correct content' do
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
