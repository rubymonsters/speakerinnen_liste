# frozen_string_literal: true

describe FeaturedProfile, type: :model do
  let(:profile_2) { FactoryBot.create(:profile, id: 2) }
  let(:profile_3) { FactoryBot.create(:profile, id: 3) }

  describe 'featured profile ids' do
    it 'returns an array of existing profiles' do
      featured_event = FactoryBot.build(:featured_profile, profile_ids: [2, 3])
      expect(featured_event.ids.length).eql? 2
      expect(featured_event.ids.first).eql? profile_2
      expect(featured_event.ids.last).eql? profile_3
    end

    it 'does not return not existing profiles' do
      featured_event = FactoryBot.build(:featured_profile, profile_ids: [2, 4, 5])
      expect(featured_event.ids.length).eql? 1
      expect(featured_event.ids.first).eql? profile_2
    end
  end
end
