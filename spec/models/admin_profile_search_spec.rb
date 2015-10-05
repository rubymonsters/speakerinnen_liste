describe 'profile', type: :model do
  describe '.profile_search' do
    let!(:ada) { FactoryGirl.create(:profile, firstname: 'Ada') }

    it 'searches for all profiles by firstname and lastname' do
      expect(Profile.search('ada').count).to eq 1
    end
  end
end
