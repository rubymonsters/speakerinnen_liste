# frozen_string_literal: true

RSpec.feature 'Featured Profile', type: :feature do
  describe 'when a featured profile is added' do
    let!(:profile_2) { FactoryBot.create(:profile, id: 2) }
    let!(:profile_3) { FactoryBot.create(:profile, id: 3) }

    before do
      @featured_event = FeaturedProfile.create(title: 'New featured Event', description: 'Description for featured event', profile_ids: [2, 3], public: true)
    end

    it 'shows featured event on home page' do
      visit root_path
      expect(page).to have_content('New featured Event')
      expect(page).to have_content('Description for featured event')
    end

    it 'shows link to featured profiles on home page' do
      visit root_path
      expect(page).to have_link('Factory Girl')
    end

    it 'does not show unpublished featured profiles on home page' do
      @featured_event.public = false
      @featured_event.save
      visit root_path
      expect(page).to have_no_content('New featured Event')
      expect(page).to have_no_link('Factory Girl')
    end
  end
end
