#require 'rails_helper'
require 'spec_helper'

describe ProfilesController do

  describe "test index action" do
    let!(:user) { FactoryGirl.create(:published) }
    let!(:user2) { FactoryGirl.create(:user, email: "test@anders.com") }

    before do
      get :index
    end

    it "should display index" do
      expect(response).to be_success
      expect(response.response_code).to eq(200)
      expect(response).to render_template("index")
    end

    it "should display profiles" do
      expect(assigns(:profiles)).to eq([user])
    end

    it "should not include unpublished profiles" do
      expect(assigns(:profiles)).not_to include(user2)
    end
  end

  describe "show profile" do
    let!(:user) { FactoryGirl.create(:unpublished) }
    let!(:user1) { FactoryGirl.create(:published, email: "test@anders.com") }
    let!(:admin) { FactoryGirl.create(:admin, email: "admin@anders.com") }

    describe "of unpublished user" do
      it "is not permited for unauthorized not signed in user" do
        get :show, id: user.id
        expect(response).to redirect_to("/de/profiles")
      end

      it "is not permited for unauthorized signed in user" do
        sign_in user1
        get :show, id: user.id
        expect(response).to redirect_to("/de/profiles")
      end

      it "is permited for own profile" do
        sign_in user
        get :show, id: user.id
        expect(response).to render_template(:show)
      end

      it "is permited for admin" do
        sign_in admin
        get :show, id: user.id
        expect(response).to render_template(:show)
      end
    end

    describe "of published profile" do
      it "should be seen by all users" do
        get :show, id: user1.id
        expect(response).to render_template(:show)
      end
    end
  end
end
