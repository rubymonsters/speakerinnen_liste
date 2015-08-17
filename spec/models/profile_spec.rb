require 'spec_helper'

describe 'Profile' do
	it "has a valid factory" do
	expect(FactoryGirl.build(:Profile)).to be_valid

end
	it "is invalid without a firstname" do
	profile = FactoryGirl.create(:profile, firstname: nil)
	expect(profile.errors[:firstname].size).to eq(0)
end
	it "is invalid without a lastname" do
	profile = FactoryGirl.build(:profile, lastname: nil)
	expect(profile.errors[:lastname].size).to eq(0)
end
	it "is invalid without an email address" do
	profile = FactoryGirl.build(:profile, email: nil)
	expect(profile.errors[:email].size).to eq(0)
end
	it "returns a profile's full name as a string" do
	Profile = FactoryGirl.build(:Profile,
	firstname: "Jane", lastname: "Doe")
	expect(profile.name).to eq "Jane Doe"
end
end