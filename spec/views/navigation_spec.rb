require 'spec_helper'

shared_examples_for "successful sign in" do
  it { should have_content(I18n.t("devise.sessions.signed_in")) }
  it { should have_link(I18n.t("layouts.application.logout"),destroy_profile_session_path) }
end

describe "navigation" do
  subject { page }

  before do
    @links_array = [categorization_admin_tags_path, admin_categories_path, admin_profiles_path]
    @lang_links_map = {
      'en' => ['Categories','Tags','Profiles'],
      'de' => ['Kategorien', 'Tags', 'Profile']
    }
  end

  ['en','de'].each do |language|
    context "signed in as normal user" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in_with_language user, language
      end
      it_should_behave_like "successful sign in"
      it { should have_no_link('Admin', admin_root_path) }

      #When you go to the start page
      #You can't see the admin link
    end

    context "signed in as admin" do
      let(:user) { FactoryGirl.create(:admin) }
      before do
        sign_in_with_language user, language
      end
      it_should_behave_like "successful sign in"
      it { should have_link('Admin', admin_root_path) }

      describe "access admin actions" do
        before { click_on 'Admin' }
        #find(:xpath, "//a[contains(@href,'#{admin_root_path}')]").click
        it { should have_content('Administration') }
        it "should have localized links" do
          @lang_links_map[language].each_with_index do |link, index|
            expect(page).to have_link(link, @links_array[index])
          end
        end
      end
      #When you go to the start page
      #Then you see the admin link
      #Then you are able to click on the admin link
    end
  end
end
