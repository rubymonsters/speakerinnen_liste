require 'spec_helper'
include SignInHelper																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																						

describe "Profile" do
	before (:each) do
		@attrib = {  :firstname => "test2",
					:lastname  => "user2",
					:email     => "test2@user.com",
					:password  => "test2user2",
					:admin	   => true,
					:confirmed_at => Time.now 
				}
	end
	it 'should make sure the user is an admin' do
		@user = Profile.create!(@attrib)
		expect(@user.admin).to be_truthy
	end

	it 'should return false if user is not an admin' do
		@user = Profile.create!(@attrib.merge(:admin => ""))
		expect(@user.admin).to be_falsey
	end
	
	it 'should allow that the admin can edit all Profiles' do
		@user = Profile.create!(@attrib)
		profile2 = FactoryGirl.create(:profile, email: 'me1@email.com')
		sign_in @user
		first(:link, 'EN').click
		click_link 'Admin'
		click_on 'Profiles'
		expect(page).to have_content profile2.firstname
		first(:link, 'Edit').click
		expect(page).to have_content('Administration::Profiles::Edit')
		
	end
	
	it 'should allow admin to publish profiles' do
		@user = Profile.create!(@attrib)
		profile2 = FactoryGirl.create(:profile, email: 'me1@email.com')
		sign_in @user
		first(:link, 'EN').click
		click_link 'Admin'
		click_on 'Profiles'
		expect(page).to have_content  "invisible"
		expect(page).not_to have_button  "public"
		first(:link, 'invisible').click
		expect(page).to have_content 'public'
	end
	
	it 'should allow admin to comment on a profile' do
		@user = Profile.create!(@attrib)
		profile2 = FactoryGirl.create(:profile, email: 'me1@email.com')
		sign_in @user
		first(:link, 'EN').click
		click_link 'Admin'
		click_on 'Profiles'
		expect(page).to have_content  "Administration::Profiles"
		expect(page).to have_button  "Add comment"
	end
	
	it 'should allow admin to view all profiles' do
		@user = Profile.create!(@attrib)
		sign_in @user
		first(:link, 'EN').click
		click_link 'Admin'
		expect(page).to have_content('Administration')
		click_on 'Profiles'
		expect(page).to have_content('Administration::Profiles')
	end
end
