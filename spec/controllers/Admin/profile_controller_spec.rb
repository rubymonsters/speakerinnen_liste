require 'spec_helper'
include AuthHelper


describe Admin::ProfilesController, type: :controller do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin, {email: "sam@mail.com"})) }
  let!(:non_admin) { Profile.create!(FactoryGirl.attributes_for(:published, {email: "ral@mail.com"})) }

  describe 'GET index' do
    before(:each) do
      sign_in admin
      @profile = Profile.create!(FactoryGirl.attributes_for(:admin, {email: "ev@mail.com", firstname: "Awe"}))
      @profile1 = Profile.create!(FactoryGirl.attributes_for(:admin, {email: "ev1@mail.com", firstname: "NotInc"}))
    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

    describe "when search param is provided" do
      before { get :index, { search: "Awe" } }

      it "should return success" do
        expect(response.status).to eq 200
      end

      it "should redirect to the admin profiles page" do 
        expect(response).to render_template(:index)
      end

      it "should contain queried results" do
        expect(assigns(:profiles)).to_not include(@profile1)
      end
    end

    describe "when search param is not provided" do
      before { get :index }

      it "should return success" do
        expect(response.status).to eq 200
      end

      it "should redirect to the admin profiles page" do 
        expect(response).to render_template(:index)
      end

      it "should contain all results" do
        expect(assigns(:profiles)).to include(@profile)
        expect(assigns(:profiles)).to include(@profile1)
      end
    end
  end

  describe 'GET show' do
    describe "when user is admin" do
      before(:each) do
        sign_in admin
        get :show, { id: non_admin.id }, format: :json

        puts "###### RESPONSE: #{response.body.inspect}"
      end

      specify{ expect(response.status).to eq 200 }
      specify{ expect(response).to render_template(:show) }
    end

    describe "when user is not admin" do
      before(:each) do
        sign_in non_admin
        get :show, { id: admin.id }
      end
    end
  end

  describe 'edit profile' do
    
  end
end
#WP
