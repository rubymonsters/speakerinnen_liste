describe 'PagesController', type: :request do
  let!(:old_profile) { create(:published_profile, main_topic_en: 'history') }
  let!(:profile_unpublished) { create(:unpublished_profile) }
  let(:admin) { create(:profile, :admin) }
  let!(:category) { create(:cat_science) }
  
  describe 'GET /' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end

    it 'shows the last 7 published profiles and excludes older and unpublished profiles' do
      create_list(:published_profile, 7, main_topic_en: 'Mathematik Genie')
      get '/'
      expect(assigns(:newest_profiles).size).to eq(7)
      expect(assigns(:newest_profiles)).not_to include(old_profile)
      expect(assigns(:newest_profiles)).not_to include(profile_unpublished)
    end
  end

  describe 'section linking to all speakerinnen' do
    it 'is not shown on the main site' do
      host! 'speakerinnen.org'
      get '/en'
      expect(response.body).not_to include('No Speakerin found')
      expect(response.body).not_to include('Explore more')
    end

    it 'is shown with a region specific title on the vorarlberg site' do
      host! 'vorarlberg.speakerinnen.org'
      get '/en'
      expect(response.body).to include('No Speakerin found in Vorarlberg?')
    end

    it 'is shown with a region specific title on the ooe site' do
      host! 'ooe.speakerinnen.org'
      get '/de'
      expect(response.body).to include('Keine Speakerin in Oberösterreich gefunden?')
    end

    it 'links to the main site in the current locale' do
      host! 'vorarlberg.speakerinnen.org'
      get '/de'
      link = Nokogiri::HTML(response.body).at_css('a.btn:contains("Hier weitersuchen")')
      expect(link['href']).to eq('http://speakerinnen.org/de')
    end
  end
end
