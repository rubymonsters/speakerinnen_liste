require 'spec_helper'

describe 'profile', type: :model do

context "when user is no admin" do
let(:profile) { FactoryGirl.create(:profile) }
 
 it "has a valid factory" do
   expect(FactoryGirl.build(:profile)).to be_valid
   end
  
it "by default isn't admin" do
  expect(profile.admin).to be(false)
  end

it 'is invalid without firstname' do
   profile = FactoryGirl.build(:profile, firstname: nil)
    profile.valid?
   expect(profile.errors[:firstname].size).to eq(0)
 end

it 'returns a profile fullname as a string' do
    expect(profile.fullname).to eq "Factory Girl"
   end
end
context "when user is admin" do
  let(:admin) { FactoryGirl.create(:admin) }
    end

context 'invalid emails' do
  let(:profile) { FactoryGirl.create(:profile) }

it 'is invalid without email' do
    profile = FactoryGirl.build(:profile, email: nil)
    expect(profile.errors[:email].size).to eq(0)
  end

it "is invalid when email address is already taken" do
Profile = Profile.new(firstname: 'Jane', lastname: 'Tester',email: 'FactoryGirl@test.de')
expect(profile.errors[:email].size).to eq(0)
    end
  end
end

#work in progress
