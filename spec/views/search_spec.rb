describe 'profile search', type: :view do
  before do
    visit root_path
    click_button I18n.t(:search, scope: 'pages.home.search')
    render_template(partial: '_profile_search')
  end

  context 'quick search activated' do
    it 'should show quick search' do
      expect(page).to have_css('#quick-search.visible')
    end

    it 'should hide detailed search' do
      expect(page).to have_css('#detailed-search.hidden')
    end
  end

  context 'detailed search activated' do
    before do
      find('#detailed-search-trigger').click
      render_template(partial: '_profile_search')
    end

    it 'should show detailed search' do
      expect(page).to have_css('#detailed-search.visible')
    end

    it 'should hide quick search' do
      expect(page).to have_css('#quick-search.hidden')
    end
  end
end
