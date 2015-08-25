include Warden::Test::Helpers
Warden.test_mode!
feature 'admin panel', :devise do
	after(:each) do
		Warden.test_reset!
	end

	scenario 'admin can view all profiles' do
		admin = FactoryGirl.create(:admin)
		sign_in admin
		first(:link, 'EN').click
		click_link 'Admin'
		expect(page).to have_content('Administration')
		click_on 'Profiles'
		expect(page).to have_content('Administration::Profiles')

	end

	scenario 'non admin cannot see admin link' do
		profile = FactoryGirl.create(:profile)
		sign_in profile
		first(:link, 'EN').click

		expect(page).not_to have_content('Admin')
	end

	scenario 'admin can delete user profile' do
		skip('needs :js')
	end

	scenario 'admin can edit user profile' do
		admin = FactoryGirl.create(:admin)
		profile2 = FactoryGirl.create(:profile, email: 'me1@email.com')
		sign_in admin
		first(:link, 'EN').click
		click_link 'Admin'
		click_on 'Profiles'
		expect(page).to have_content profile2.firstname
		first(:link, 'Edit').click
		expect(page).to have_content('Administration::Profiles::Edit')

	end

	scenario 'admin can show individual user profiles' do
		admin = FactoryGirl.create(:admin)
		profile3 = FactoryGirl.create(:profile, email: 'me2@email.com')
		sign_in admin
		first(:link, 'EN').click
		click_link 'Admin'
		click_on 'Profiles'
		expect(page).to have_content profile3.firstname
		first(:link, "#{profile3.firstname} #{profile3.lastname}").click
		expect(page).to have_content 'Admin::Profiles::show'

	end

	scenario 'admin can make profile public' do
		admin = FactoryGirl.create(:admin)
		profile4 = FactoryGirl.create(:profile, email: 'me4@email.com')
		sign_in admin
		first(:link, 'EN').click
		click_link 'Admin'
		click_on 'Profiles'
		expect(page).to have_content  "invisible"
		expect(page).not_to have_button  "public"
		first(:link, 'invisible').click
		expect(page).to have_content 'public'

	end
end