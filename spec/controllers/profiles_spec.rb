#require 'rails_helper'
require 'spec_helper'

describe ProfilesController do 
  
  describe "test index action" do
    let!(:user) { FactoryGirl.create(:published) }
    let!(:user2) { FactoryGirl.create(:user, email: "test@anders.com") }
    let!(:user3) { FactoryGirl.create(:published, email: "test@nochanders.com") }
    
    before do
      get :index
    end

    it "should display index" do
      expect(response).to be_success
      expect(response.response_code).to eq(200)
      expect(response).to render_template("index")
    end

    it "should display published profiles" do
      expect(assigns(:profiles).sort).to eq([user, user3].sort)
    end

    it "should not include unpublished profiles" do
      expect(assigns(:profiles)).not_to include(user2)
    end
  end
end


