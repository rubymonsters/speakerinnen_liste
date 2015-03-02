require 'spec_helper'

describe ProfilesSearch, type: :model do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Gertrud', lastname: 'Mueller', twitter: 'Apfel', city: 'Berlin') }

  describe 'results' do
    context 'quick search' do
      it 'does not return profiles that do not match the given search string' do
        expect(ProfilesSearch.new(quick: 'Horstin').results).to be_empty
      end

      it 'does return profiles that match the lastname' do
        expect(ProfilesSearch.new(quick: 'Muell').results).to eq [profile]
      end

      it 'does return profiles that match the twittername' do
        expect(ProfilesSearch.new(quick: 'apfel').results).to eq [profile]
      end

      it 'does return profiles that match the topic' do
        profile.topic_list.add("obst")
        profile.save!

        expect(ProfilesSearch.new(quick: 'obst').results).to eq [profile]
      end

      it 'does return nothing if only quick is given and empty' do
        expect(ProfilesSearch.new(quick: '').results).to be_empty
      end
    end

    context 'detailed search' do
      it 'does return profiles that match the given search string' do
        expect(ProfilesSearch.new({city: 'Berli'}).results).to eq [profile]
      end
    end
  end
end
