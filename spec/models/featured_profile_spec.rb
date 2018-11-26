# frozen_string_literal: true

describe FeaturedProfile, type: :model do
  let!(:featured_profile) { FactoryBot.create(:featured_profile) }
  let!(:profile) { FactoryBot.create(:profile, id: 1) }

  describe 'featured profile' do
    it "has a title" do
      #expect(featured_profile.title).to eq 'gaming'
    end

    it "points to the profiles" do
    @featured = FeaturedProfile.featured_women

    expect(@featured.first.id).to eq 1
    expect(@featured.first.firstname).to eq 'Factory'
  end
  end
end
