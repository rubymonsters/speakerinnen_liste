require 'spec_helper'

shared_examples_for "successful sign in" do
  it { should have_content("Erfolgreich angemeldet") }
  it { should have_link('Ausloggen',destroy_profile_session_path) }  
end

describe "navigation" do
  subject { page }

  before do
    #puts "env:"+Rails.env
  end

  context "signed in as normal user" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
    end
    it_should_behave_like "successful sign in"
    it { should have_no_link('Admin',admin_root_path) }

    #When you go to the start page
    #You can't see the admin link
  end

  context "signed in as admin" do
    let(:user) { FactoryGirl.create(:admin) }
    before do
      sign_in user
    end
    it_should_behave_like "successful sign in"
    it { should have_link('Admin',admin_root_path) }

    describe "click on admin link" do
    end
    #When you go to the start page
    #Then you see the admin link
    #Then you are able to click on the admin link
  end

end
