# describe ProfilesSearch, type: :model do
#   let!(:profile) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace', twitter: 'alovelace', city: 'London', country: 'GB', languages: 'English') }
#   # have to add city and twitter because the search needs them for params, at least as empty strings
#   let!(:profile2) { FactoryGirl.create(:published, firstname: 'Marie', lastname: 'Curie', twitter: 'marieecurie', city: 'Paris', country: 'FR') }

#   let!(:profile_not_matched) { FactoryGirl.create(:published, firstname: 'Angela', lastname: 'Davis') }
#   let!(:profile_not_published) { FactoryGirl.create(:unpublished, firstname: 'Fred') }

#   describe 'results' do
#     it 'does not return unpublished profiles' do
#       expect(ProfilesSearch.new(quick: 'Fred').results).to be_empty
#     end

#     context 'quick search' do
#       it 'does not return profiles that do not match the given search string' do
#         expect(ProfilesSearch.new(quick: 'Rosie').results).to be_empty
#       end

#       it 'does return profiles that match the firstname' do
#         expect(ProfilesSearch.new(quick: 'Ada').results).to eq [profile]
#       end

#       it 'does return profiles that match the lastname' do
#         expect(ProfilesSearch.new(quick: 'Love').results).to eq [profile]
#       end

#       it 'does return profiles that match the firstname and the lastname' do
#         expect(ProfilesSearch.new(quick: 'Ada Lovelace').results).to eq [profile]
#       end

#       it 'does return profiles that match the twittername' do
#         expect(ProfilesSearch.new(quick: 'Lovelace').results).to eq [profile]
#       end

#       it 'does return profiles that match the topic' do
#         profile.topic_list.add('algorithm')
#         profile.save!

#         expect(ProfilesSearch.new(quick: 'algorithm').results).to eq [profile]
#       end

#       it 'does return nothing if only quick is given and empty' do
#         expect(ProfilesSearch.new(quick: '').results).to be_empty
#       end
#     end

#     context 'when doing a detailed search' do
#       it 'does return profiles that match the given city search string' do
#         expect(ProfilesSearch.new(city: 'Lond').results).to eq [profile]
#       end

#       it 'does return profiles that match the given language search string' do
#         expect(ProfilesSearch.new(languages: 'en').results).to eq [profile]
#       end

#       it 'does return profiles that match the given firstname search string' do
#         expect(ProfilesSearch.new(name: 'Ada').results).to eq [profile]
#       end

#       it 'does return profiles that match the given lastname search string' do
#         expect(ProfilesSearch.new(name: 'Lovelace').results).to eq [profile]
#       end

#       it 'does return profiles that match the given firstname and lastname search string' do
#         expect(ProfilesSearch.new(name: 'Ada Lovelace').results).to eq [profile]
#       end

#       it 'does return profiles that match the given twitter search string' do
#         expect(ProfilesSearch.new(twitter: 'Love').results).to eq [profile]
#       end

#       it 'does return profiles that match the given topic search string' do
#         profile.topic_list.add('algorithm')
#         profile.save!

#         expect(ProfilesSearch.new(topics: 'algorithm').results).to eq [profile]
#       end

#       it 'returns any profile that matches one of the given topics' do
#         profile.topic_list.add('algorithm', 'mathematic')
#         profile.save!
#         profile2.topic_list.add('algorithm')
#         profile2.save!

#         expect(ProfilesSearch.new(topics: 'algorithm').results).to match_array [profile, profile2]
#       end

#       it 'does return nothing if detailed search is empty' do
#         expect(ProfilesSearch.new(topics: '', twitter: '', name: '', city: '', country: '', languages: '').results).to be_empty
#       end
#     end
#   end
# end
