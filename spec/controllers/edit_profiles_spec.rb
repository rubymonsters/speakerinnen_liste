require 'spec_helper'

describe "edit_profiles" do
	context "signed in as admin" do
      let(:profile) { FactoryGirl.create(:admin) }
      before do
        sign_in profile, language
      end
end
