describe 'profile', type: :model do
  describe '.profile_search' do
    let!(:ada) { FactoryGirl.create(:profile, firstname: 'Ada') }

    # it 'searches for all profiles by firstname and lastname' do
    # skip: "until elasticsearch is also implemented in admin area"
    #   expect(Profile.search('Ada').count).to eq 1
    # end
  end
end
