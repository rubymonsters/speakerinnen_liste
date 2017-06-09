require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

describe 'profile search', elasticsearch: true, type: :view do
  let!(:ada) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace', city: 'London', country: 'GB', twitter: 'Adalove', languages: 'Spanish, English', iso_languages: ['en', 'es']) }

    context 'on startpage' do
      before { visit root_path }
      it 'shows button search' do

        expect(page).to have_selector('#search')
      end

      it 'shows autofill' do
        expect(page).to have_selector('.typeahead')
      end
    end

    context 'on profile_search page' do
      before { visit profiles_path }

      it 'shows button search' do
        expect(page).to have_selector('#search')
      end

      it 'shows autofill' do
      expect(page).to have_selector('.typeahead')
      end
    end
end
