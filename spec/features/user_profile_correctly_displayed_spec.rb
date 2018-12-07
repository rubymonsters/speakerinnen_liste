RSpec.feature 'DisplayProfile', type: :feature do
  describe 'When viewing a user profile page ' do

    let!(:ada) {FactoryBot.create(:published,
                                    firstname: 'Ada',
                                    lastname: 'Lovelace',
                                    topic_list: ['fruehling'],
                                    bio: 'Bio von Ada',
                                    attributes: { main_topic: 'Teatime', locale: :en }
                                    )}

    let!(:Inge){FactoryBot.create(:published,
                                    firstname: 'Inge',
                                    lastname: 'Inga',
                                    topic_list: ['fruehling', 'sommer'],
                                    bio: 'Bio von Inge',
                                    attributes: { main_topic: 'Sauerkraut', locale: :de }
                                    )}

    it 'displays profile correcly in English' do
      visit '/en'
      click_link('Ada Lovelace', match: :first)

      expect(page).to have_css('h1'), 'one  of the fullname'
      expect(page).to have_content('My topics')
      expect(page).to have_content('My bio')
    end

    it 'displays profile correcly in German' do
      visit '/de'
      click_link('Inge Inga', match: :first)

      expect(page).to have_css('h1'), 'one headline of the fullname'
      expect(page).to have_content('Meine Themen')
      expect(page).to have_content('Meine Biografie')

    end
  end
end
