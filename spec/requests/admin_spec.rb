#when signed in as admin,admin can publish,edit,delete and comment on a profile
require 'spec_helper'
shared_examples_for "successful sign in" do
it { should have_content(I18n.t("devise.sessions.signed_in")) }
it { should have_link(I18n.t("layouts.application.logout"),destroy_profile_session_path) }
end
describe 'admin actions' do
	let!(:profile) { FactoryGirl.create(:admin) }
	 before do
       sign_in profile
    end
it 'signs in admin' do
      click_link 'admin'
      expect{page}.should have_content 'Administration'
      click_link 'profiles'
      expect{page}.should have_content 'Administration::Profiles'
	end
	it 'edits profiles' do
		click_link 'edit'
		expect{page}.should have_content 'Administration::Profiles:edit'
	end
end




