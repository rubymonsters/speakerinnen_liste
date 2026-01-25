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
end
