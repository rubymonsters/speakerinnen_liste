describe 'profile search', elasticsearch: true, type: :view do
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
