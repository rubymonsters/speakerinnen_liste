require 'spec_helper'

describe Profile do

  before do
  @profile = Profile.new( firstname: "Factory", lastname: "Girl", email: "FactoryGirl@test.de",
                   password: "123foobar", password_confirmation: "123foobar")
  end

  subject { @profile }

  it { should respond_to(:firstname) }
  it { should respond_to(:lastname) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

 it 'should be_invalid without firstname' do
   # before { @profile.firstname = :nill }       
    #expect(@profile.errors[:firstname].size).to eq(0)
    expect(@profile).to be_invalid 

  end
it 'should be_invalid without lastname' do
	 #before { @profile.firstname = :nill } 
  # expect (@profile.errors[:lastname].size).to eq(0)
   expect(@profile).to be_invalid
  end

   

 context 'when email is not present' do
    before { @profile.email = " " }
    it { should_not be_valid }
  end
   

   context "when email address is already taken" do
    before do
      profile_with_same_email = @profile.dup
      profile_with_same_email.email = @profile.email.upcase
      profile_with_same_email.save
   	  it { should_not be_valid }
 		 end
	end
end

describe "admin? is true when an admin user" do
	admin = FactoryGirl.create(:admin)
    profile.admin = true
    it {should_be_valid}
    end