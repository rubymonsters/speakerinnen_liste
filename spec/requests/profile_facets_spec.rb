describe 'Profile search facets', type: :request do
  def create_profile(city: nil, languages: ['de'], state: nil)
    create(:published_profile, main_topic_en: 'physics', city_en: city, iso_languages: languages, state: state)
  end

  before do
    create_profile(city: 'Berlin')
    create_profile(city: 'berlin')
    create_profile(city: 'Köln/Berlin')
    create_profile(city: 'Berlin, Berlin')
    create_profile(city: 'Bernau bei Berlin')
    create_profile(city: 'Hamburg und Bremen')
    create_profile(city: 'St. Pölten (AT)')
    create_profile(languages: %w[sgn de], state: 'saxony')
    create_profile(languages: ['wen'], state: 'saxony-anhalt')
    create_profile(languages: ['en'], state: 'lower-saxony')
  end

  def search(filter = {})
    get '/en/profiles', params: { search: 'physics' }.merge(filter)
  end

  it 'groups cities case-insensitively and splits them on separators' do
    search
    expect(assigns(:aggs_cities)).to include('Berlin' => 4, 'Köln' => 1, 'Hamburg' => 1, 'Bremen' => 1)
    expect(assigns(:aggs_cities).keys).not_to include('berlin')
  end

  it 'keeps three letter language codes intact' do
    search
    expect(assigns(:aggs_languages)).to include('sgn' => 1, 'wen' => 1)
  end

  {
    aggs_cities: :filter_city,
    aggs_languages: :filter_language,
    aggs_states: :filter_state
  }.each do |aggs, filter|
    it "returns as many results as the #{aggs} facet count says" do
      search
      expected = assigns(aggs)

      actual = expected.keys.index_with do |bucket|
        search(filter => bucket)
        assigns(:pagy).count
      end

      expect(actual).to eq(expected)
    end
  end

  it 'shows the city facet when the URL carries no locale' do
    get '/profiles', params: { search: 'physics' }, headers: { 'HTTP_ACCEPT_LANGUAGE' => 'en' }
    expect(assigns(:aggs_cities)).to include('Berlin' => 4)
  end
end
