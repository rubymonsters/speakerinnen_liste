require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

  describe 'profile search', elasticsearch: true, type: :view do
    let!(:ada) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace', city: 'London', country: 'GB', twitter: 'Adalove', languages: 'Spanish, English', iso_languages: ['en', 'es']) }

    context 'on startpage' do
      before { visit root_path }

      describe 'search field is visible' do
        before do
          click_button I18n.t(:search, scope: 'pages.home.search')
        end

        it 'should show search field' do
          expect(page).to have_css('#search')
        end

        it 'should show no profiles because the search field was empty' do
          expect(page).to_not have_content('Ada')
        end

        it 'should show autocomplete' do
          element = page.find('input#search')
          p element['class']
          expect(element['class']).to include ('typeahead')
        end
      end
  #     describe 'follow link to detailed search' do
  #       before do
  #         click_link I18n.t(:detailed_search, scope: 'general')
  #       end

  #       it 'should show the detailed search field' do
  #         expect(page).to have_css('#detailed-search.visible')
  #       end

  #       it 'should hide the quick search field' do
  #         expect(page).to have_css('#quick-search.hidden')
  #       end

  #       it 'should show all profiles' do
  #         expect(page).to have_content('Ada')
  #       end
  #     end
  #   end

    context 'on profile_search page' do
      before { visit profiles_path }

      describe 'search field is visible' do
        it 'should show search field' do
          expect(page).to have_css('#search')
        end

        it 'should show search field' do
          expect(page).to have_css('#search')
        end

        it 'should show no profiles because the search field was empty' do
          expect(page).to_not have_content('Ada')
        end
      end
    end
  end
end
