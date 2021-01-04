# frozen_string_literal: true

RSpec.feature 'Feature', type: :feature do
  describe 'when a feature is added' do
    let!(:profile_2) { FactoryBot.create(:profile, id: 2) }
    let!(:profile_3) { FactoryBot.create(:profile, id: 3) }

    before do
      @feature_1 = Feature.create(
        title: 'New announced Event',
        description: 'Description for announced event',
        profiles: [profile_2, profile_3],
        position: 2,
        public: true
      )

      @feature_2 = Feature.create(
        title: 'Second subject',
        description: 'Description for second subject',
        profiles: [profile_2, profile_3],
        position: 1,
        public: true
      )
    end

    it 'shows public feature on home page' do
      visit root_path
      expect(page).to have_content('New announced Event')
      expect(page).to have_content('Description for announced event')
    end

    it 'shows features on home page in the correct order' do
      visit root_path
      feature_descriptions = page.all('.feature')

      expect(feature_descriptions[0]).to have_content('Description for second subject')
      expect(feature_descriptions[1]).to have_content('Description for announced event')
    end

    it 'shows link to assigned profiles on home page' do
      visit root_path
      expect(page).to have_link('Susi Sonnenschein')
    end

    it 'does not show not public feature on home page' do
      @feature_1.public = false
      @feature_1.save
      visit root_path
      expect(page).to have_no_content('New announced Event')
    end
  end
end
