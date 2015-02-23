require 'spec_helper'

describe ProfilesSearch, type: :model do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Gertrud', lastname: 'Mueller', twitter: 'Apfel') }

  describe 'results' do
    it 'does not return profiles that do not match the given search string' do
      expect(ProfilesSearch.new('Horstin').results).to be_empty
    end

    it 'does return profiles that match the lastname' do
      expect(ProfilesSearch.new('Muell').results).to eq [profile]
    end

    it 'does return profiles that match the twittername' do
      expect(ProfilesSearch.new('apfel').results).to eq [profile]
    end

    it 'does return profiles that match the topic' do
      profile.topic_list.add("obst")
      profile.save!

      expect(ProfilesSearch.new('obst').results).to eq [profile]
    end
  end
end
