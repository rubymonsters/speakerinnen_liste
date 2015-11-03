describe 'profile', type: :model do
let(:profile) { FactoryGirl.create(:profile) }

describe 'profile settings' do
  it "has a valid factory" do
   expect(FactoryGirl.build(:profile)).to be_valid
   end

  it "by default isn't admin" do
    expect(profile.admin).to be(false)
  end

  it 'returns a profile fullname as a string' do
    expect(profile.fullname).to eq "Factory Girl"
  end

    # check again: these tests seem to be false positive
    # it 'is invalid without email' do
    #   profile_no_email = FactoryGirl.build(:profile, email: nil)
    #   expect(profile_no_email.errors[:email].size).to eq(0)
    # end

    # it "is invalid when email address is already taken" do
    #   profile_same_email = FactoryGirl.create(:profile, firstname: 'Jane', lastname: 'Tester', email: 'factorygirl@test.de')
    #   expect(profile_same_email.errors[:email].size).to eq(0)
    # end
  end

  describe '#name_or_email' do
    context 'user has no name information' do
      let(:profile_no_name) { FactoryGirl.create(:profile, firstname: nil, lastname: nil) }

      it 'return the email adress' do
        expect(profile_no_name.name_or_email).to eq "factorygirl@test.de"
      end
    end

    context 'user has name information' do
      it 'return the fullname' do
        expect(profile.name_or_email).to eq "Factory Girl"
      end
    end
  end

  describe '#slug' do
    let(:params) do
      { email: 'me@me.com', password: 'supersecret' }
    end
    subject { Profile.create(params) }

    context 'without firstname or lastname' do
      it 'builds the slug from just a random part' do
        expect(subject.slug).to match(/[0-9a-f]+/)
      end
    end # context 'without firstname or lastname'

    context 'with firstname and lastname' do
      let(:params) do
        super().merge(firstname: 'Jane', lastname: 'Doe')
      end

      it 'builds the slug from firstname and lastname' do
        expect(subject.slug).to eq 'jane-doe'
      end
    end # context 'with firstname and lastname'
  end # describe '#slug'
end
