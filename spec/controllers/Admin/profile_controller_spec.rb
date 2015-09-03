require 'spec_helper'
include AuthHelper

describe Admin::ProfilesController, type: :controller do
let!(:admin) { FactoryGirl.create(:admin) }

describe 'test index action' do
 let!(:profile2) { FactoryGirl.create(:unpublished) }
 let!(:profile1) { FactoryGirl.create(:published, email: 'test@anders.com') }
 let!(:admin) { FactoryGirl.create(:admin, email: 'admin@anders.com') }
 
 before do
 	sign_in admin
 	visit admin_profiles_path
 		end
 	end
end



# it "should get index" do
# 	get :index, page: 5, format: :json
#     expect(response.body).to include('{"id":' + profile1.id.to_s + ',"firstname"')
#   end
# end





