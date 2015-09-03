require 'spec_helper'
describe "edit_profiles" do
let!(:profile) { FactoryGirl.create(:admin) }
context "signed in as admin" do
 before do
    sign_in profile, language
	 	end
	end
end
