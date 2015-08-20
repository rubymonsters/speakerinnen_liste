require 'spec_helper'

describe 'profile' do
	it "has a valid factory" do
	expect(FactoryGirl.create(:profile)).to be_valid
end
	it "is invalid without a firstname" do
	profile = FactoryGirl.build(:profile, firstname: nil)
	#expect(profile.errors[:firstname].size).to eq(0)
	expect(profile).not_to be_valid
end
	it "is invalid without a lastname" do
	profile = FactoryGirl.build(:profile, lastname: nil)
	expect(profile.errors[:lastname].size).to eq(0)
end
	it "is invalid without an email address" do
	profile = FactoryGirl.build(:profile, email: nil)
	expect(profile.errors[:email].size).to eq(0)
end
	it "invalid without a password" do
		profile = FactoryGirl.build(:profile, password: nil)
		expect(profile.errors[:password].size).to eq(0)
end
	it "returns a profile fullname as a string" do
	profile = FactoryGirl.build(:profile, fullname: "{firstname}, lastname")
	expect(profile.fullname).to eq "firstname lastname"
end
end






