describe 'profile search' do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace', city: 'London', twitter: 'Adalove', languages: "Spanish, English") }

  let!(:profile_not_matched) { FactoryGirl.create(:published, firstname: 'Angela', city: 'New York', twitter: '@adavis' ) }

  describe 'quick search' do

    it 'displays profiles that are a partial match' do
      visit root_path
      fill_in 'profile__search', with: 'Ada'
      click_button I18n.t(:search, scope: 'pages.home.search')
      expect(page).to have_content('Ada')
    end
  end

  describe 'detailed search' do

    before do
      visit profiles_path
    end

    it 'displays profiles partial match for city' do
      within '#detailed-search' do
        fill_in I18n.t(:city, scope: 'profiles.index'), with: 'Lon'
        click_button I18n.t(:search, scope: 'pages.home.search')
      end
      expect(page).to have_content('Ada')
    end

    it 'displays profiles that match any of the selected languages' do
      within '#detailed-search' do
        select 'Spanish', :from => 'Language'
        #select I18n.t(:languages, scope: 'profiles.index'), match: 'Spanish'
        click_button I18n.t(:search, scope: 'pages.home.search')
      end
      expect(page).to have_content('Ada')
    end

    it 'displays profiles partial match for name' do
      within '#detailed-search' do
        fill_in I18n.t(:name, scope: 'profiles.index'), with: 'Love'
        click_button I18n.t(:search, scope: 'pages.home.search')
      end
      expect(page).to have_content('Ada')
    end

    it 'displays profiles partial match for twitter' do
      within '#detailed-search' do
        fill_in 'Twitter', with: 'Adal'
        click_button I18n.t(:search, scope: 'pages.home.search')
      end
      expect(page).to have_content('Ada')
    end

    it 'displays profiles partial match for topic' do
      profile.topic_list.add('Algorithm')
      profile.save!

      visit profiles_path
    end

    it 'displays profiles partial match for city' do
      within '#detailed-search' do
        fill_in I18n.t(:topics, scope: 'profiles.index'), with: 'Algorithm'
        click_button I18n.t(:search, scope: 'pages.home.search')
      end
      expect(page).to have_content('Ada')
    end

    it 'displays profiles that match any of the selected languages' do
      within '#detailed-search' do
        select LanguageList::LanguageInfo.find('es').name
        select LanguageList::LanguageInfo.find('de').name
        click_button I18n.t(:search, scope: 'pages.home.search')
      end
      expect(page).to have_content('Ada')
    end

    it 'displays profiles partial match for name' do
      within '#detailed-search' do
        fill_in I18n.t(:name, scope: 'profiles.index'), with: 'Love'
        click_button I18n.t(:search, scope: 'pages.home.search')
      end
      expect(page).to have_content('Ada')
    end

    it 'displays profiles partial match for twitter' do
      within '#detailed-search' do
        fill_in 'Twitter', with: 'Adal'
        click_button I18n.t(:search, scope: 'pages.home.search')
      end
      expect(page).to have_content('Ada')
    end

    it 'displays profiles partial match for topic' do
      profile.topic_list.add('Algorithm')
      profile.save!

      visit profiles_path
      within '#detailed-search' do
        fill_in I18n.t(:topics, scope: 'profiles.index'), with: 'Algo'
        click_button I18n.t(:search, scope: 'pages.home.search')
      end
      expect(page).to have_content('Ada')
    end
  end
end

describe 'search for profile' do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Horstine') }

  it 'displays profiles that are a partial match' do
    visit root_path
    fill_in 'search-field', with: 'Horstin'
    click_button 'Suche'
    expect(page).to have_content('Horstine')
  end

end
