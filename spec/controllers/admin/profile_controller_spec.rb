require '../../spec_helper'

shared_examples_for "successful sign in" do
  it { should have_content(I18n.t("devise.sessions.signed_in")) }
  it { should have_link(I18n.t("layouts.application.logout"),destroy_profile_session_path) }
end

describe "admin profiles", :broken => false do
  subject { page }

  before do
    @links_array = [categorization_admin_tags_path, admin_categories_path, admin_profiles_path]
    @lang_links_map = {
      'en' => ['Categories','Tags','Profiles'],
      'de' => ['Kategorien', 'Tags', 'Profile']
    }
  end

  ['en','de'].each do |language|
    context "signed in as admin" do
      let(:profile) { FactoryGirl.create(:admin) }
      before do
        sign_in profile, language
      end
      it_should_behave_like "successful sign in"
      it { should have_link('Admin', admin_root_path) }
  end
  context "clicked on admin_profiles_path" do 

      it "should show list of profiles" do 
        get :show, id: profiles_path(id)
        expect(response).to render_template(:show)
      end
      
      it "should be able to edit profiles" do
        
      end
  end
end
end