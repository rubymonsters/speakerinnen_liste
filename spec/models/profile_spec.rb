 require 'spec_helper'

 describe Profile do
 let!(:profile) { FactoryGirl.build(:profile) }
 let!(:admin) { FactoryGirl.create(:admin) } 
 
 it "has a valid factory" do
   expect(FactoryGirl.build(:profile)).to be_valid
   end
  
 it 'is invalid without firstname' do
   profile = FactoryGirl.build(:profile, firstname: nil)
    profile.valid?
   expect(profile.errors[:firstname].size).to eq(0)
 end

 it 'returns a profile fullname as a string' do
    expect(profile.fullname).to eq "Factory Girl"
   end
  
 it 'is invalid without email' do
    profile = FactoryGirl.build(:profile, email: nil)
    expect(profile.errors[:email].size).to eq(0)
   end
it 'should test if user is admim' do

 end

 it 'should test if user is non admin' do
  end

 it "by default isn't admin" do
  
  end

 it 'should ensure user can sign in using twitter' do
 end  

 it 'should make sure the twitter symbol is correct' do
  end
 end

# it "should create a new instance given valid attributes" do
    
#    end
