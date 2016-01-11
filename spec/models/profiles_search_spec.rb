describe ProfilesSearch, type: :model do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace', twitter: 'alovelace', city: 'London', languages: 'English') }
  # have to add city and twitter because the search needs them for params, at least as empty strings
  let!(:profile2) { FactoryGirl.create(:published, firstname: 'Marie', lastname: 'Curie', twitter: 'marieecurie', city: 'Paris') }

  let!(:profile_not_matched) { FactoryGirl.create(:published, firstname: 'Angela', lastname: 'Davis') }
  let!(:profile_not_published) { FactoryGirl.create(:unpublished, firstname: 'Fred') }

  describe 'results' do
    it 'does not return unpublished profiles' do
      expect(ProfilesSearch.new(quick: 'Fred').results).to be_empty
    end

    context 'quick search' do
      it 'does not return profiles that do not match the given search string' do
        expect(ProfilesSearch.new(quick: 'Rosie').results).to be_empty
      end

      it 'does return profiles that match the firstname' do
        expect(ProfilesSearch.new(quick: 'Ada').results).to eq [profile]
      end

      it 'does return profiles that match the lastname' do
        expect(ProfilesSearch.new(quick: 'Love').results).to eq [profile]
      end

      # should work if elasticsearch is implemented
      # it 'should be possible to use wildcard *'
      #   expect(ProfilesSearch.new(quick: 'Ada Lovela*e').results).to eq [profile]
      # end

      it 'does return profiles that match the firstname and the lastname' do
        expect(ProfilesSearch.new(quick: 'Ada Lovelace').results).to eq [profile]
      end

      # should work if elasticsearch is implemented
      # it 'does return profiles that match firstname and lastname using the AND operator'
      #   expect(ProfilesSearch.new(quick: 'Ada AND Lovelace').results).to eq [profile]
      # end

      it 'does return profiles that match the twittername' do
        expect(ProfilesSearch.new(quick: 'Lovelace').results).to eq [profile]
      end

      it 'does return profiles that match the topic' do
        profile.topic_list.add('algorithm')
        profile.save!

        expect(ProfilesSearch.new(quick: 'algorithm').results).to eq [profile]
      end

      # should work if elasticsearch is implemented
      # it 'does return profiles that match multiple topics' do
      #   profile.topic_list.add('algorithm', 'ruby')
      #   profile.save!

      #   expect(ProfilesSearch.new(quick: 'algorithm AND ruby').results).to eq [profile]
      # end

      # it 'does return profiles that match either one or another topic by the OR operator' do
      #   profile.topic_list.add('algorithm', 'ruby')
      #   profile.save!
      #   profile2.topic_list.add('maths', 'rails')
      #   profile2.save!

      #   expect(ProfilesSearch.new(quick: 'rails OR ruby').results).to eq [profile, profile2]
      # end

      it 'does return nothing if only quick is given and empty' do
        expect(ProfilesSearch.new(quick: '').results).to be_empty
      end
    end

    context 'when doing a detailed search' do
      it 'does return profiles that match the given city search string' do
        expect(ProfilesSearch.new(city: 'Lond').results).to eq [profile]
      end

      it 'does return profiles that match the given language search string' do
        expect(ProfilesSearch.new(languages: 'en').results).to eq [profile]
      end

      it 'does return profiles that match the given firstname search string' do
        expect(ProfilesSearch.new(name: 'Ada').results).to eq [profile]
      end

      it 'does return profiles that match the given lastname search string' do
        expect(ProfilesSearch.new(name: 'Lovelace').results).to eq [profile]
      end

      it 'does return profiles that match the given firstname and lastname search string' do
        expect(ProfilesSearch.new(name: 'Ada Lovelace').results).to eq [profile]
      end

      # should work if elasticsearch is implemented
      # it 'does return profiles that match firstname and lastname using the AND operator'
      #   expect(ProfilesSearch.new(quick: 'Ada AND Lovelace').results).to eq [profile]
      # end

      # should work if elasticsearch is implemented
      # it 'does return profiles that match multiple topics' do
      #   profile.topic_list.add('algorithm', 'ruby')
      #   profile.save!

      #   expect(ProfilesSearch.new(quick: 'algorithm AND ruby').results).to eq [profile]
      # end

      # it 'does return profiles that match either one or another topic by the OR operator' do
      #   profile.topic_list.add('algorithm', 'ruby')
      #   profile.save!
      #   profile2.topic_list.add('maths', 'rails')
      #   profile2.save!

      #   expect(ProfilesSearch.new(quick: 'rails OR ruby').results).to eq [profile, profile2]
      # end

      # should work if elasticsearch is implemented
      # it 'should be possible to use wildcard *'
      #   expect(ProfilesSearch.new(quick: 'Ada Lovela*e').results).to eq [profile]
      # end
    end
  end
end
