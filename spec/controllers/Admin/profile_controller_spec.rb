require 'spec_helper'
include AuthHelper

describe Admin::ProfilesController, type: :controller do
describe 'test index action' do
 let(:admin) { FactoryGirl.create(:admin) } 
   before do
   	sign_in admin
     get :index
    end
    it 'should display index' do
      expect(response).to be_success
      #expect(response.response_code).to eq(200)
      expect(response).to render_template('index')
    end
    end
end
 
 