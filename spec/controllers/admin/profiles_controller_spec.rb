require 'spec_helper'
#describe "signed in as admin", :broken => false,:type => :controller do
  #subject { Profiles }

  #before do
   # @links_array = [categorization_admin_tags_path, admin_categories_path, admin_profiles_path]
    #@lang_links_map = {
     # 'en' => ['Categories','Tags','Profiles'],
      #'de' => ['Kategorien', 'Tags', 'Profile']
  #  }
  #end
 #end
  #['en','de'].each do |language|
  		#shared_examples_for "successful sign in" do
  		#it { should have_content(I18n.t("devise.sessions.signed_in")) }
  		#it { should have_link(I18n.t("layouts.application.logout"),destroy_profile_session_path) }
#end
  #	end

feature 'As an admin I manage profiles of the system' do
  context 'signed in as admin' 
    before(:each) do
      admin = create(:admin_user)
      signin_as(admin, :scope => :user)
    end

end

    context 'admin sees all the profiles' do
      visit admin_profiles_path
      expect(page).to have_content('List of profiles')
    end

    context 'admin edits profiles'do
    profile=FactoryGirl.create(:profile)
    signin_as(profile, :scope=>:profile)
    visit edit_profile_path(profile)
end

context 'admin deletes profiles' do
	end
	context 'admin publish profiles' do 
	end 


   # context "click on admin_profiles_path", :type => :controller do
 # 	it "should show list of profiles" do
  #		get :index,  format: :json
  #		#expect(response.length).to eq 11
  		#expect(response).to render_template(:show)
#
#end
#end

  #context 'Logged in user who is not an admin' do
   # before(:each) do
    #  user = create(:user)
     # login_as(user, :scope => :user)
   # end

    #scenario 'User cannot see the orders' do
     # visit admin_orders_path
      #expect(current_path).to eq('/')
    #end
  #end

#end

 #context "signed in as admin" do
  #    let(:profile) { FactoryGirl.create(:admin) }
     # before do
       # sign_in profile, language
     # end
     # it_should_behave_like "successful sign in"
      #it { should have_link('Admin', "/admin") }
  #end


