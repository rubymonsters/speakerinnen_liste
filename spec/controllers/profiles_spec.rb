require 'spec_helper'

describe ProfilesController do 
  
  let!(:user) { FactoryGirl.create(:published, topic_list: ["gender"]) }
  let!(:unpublished_user) { FactoryGirl.create(:user, email: "test@anders.com", topic_list: ["gender", "taekwondo", "dance"]) }
  let!(:user_gender_dance) { FactoryGirl.create(:published, email: "test@nochanders.com", topic_list: ["gender", "dance"]) }
  let!(:user_dance) { FactoryGirl.create(:published, email: "test@nochganzanders.com", topic_list: ["dance"]) }
  let!(:admin) { FactoryGirl.create(:admin, email: "admin@nochganzanders.com") }
  let!(:category) { FactoryGirl.create(:category, name: "diversity") }
 
  describe "index action" do
  
    before { get :index }

    it "should display index page" do
      expect(response).to be_success
      expect(response).to render_template("index")
    end

    it "should display only published profiles" do
      assigns(:profiles).should =~ [user, user_gender_dance, user_dance]
    end

    it "should not display unpublished profiles" do
      expect(assigns(:profiles)).not_to include(unpublished_user)
    end

    it "should display only profiles with gender tag" do
      get :index, {:topic => "gender"}
      assigns(:profiles).should =~ [user, user_gender_dance]
      expect(assigns(:profiles)).not_to include(unpublished_user, user_dance)
    end

    it "should display only profiles with dance tag" do
      get :index, {:topic => "dance"}
      assigns(:profiles).should =~ [user_gender_dance, user_dance]
      expect(assigns(:profiles)).not_to include(user, unpublished_user)
    end
  end


  describe "category action" do
    
    context "category has no tags and should redirect to list of all profiles" do

      before { get :category, category_id: category.id }
      it { expect(response).to redirect_to(profiles_path(locale: 'de')) }
      it { assigns(:profiles).should =~ [user, user_gender_dance, user_dance] }
    end

    context "category diversity has tag gender and displays published profiles with tag gender" do

      before { ActsAsTaggableOn::Tag.find_by_name("gender").categories << category }
      before { get :category, category_id: category.id }
      it { expect(assigns(:tags)).to eq([ActsAsTaggableOn::Tag.find_by_name("gender")]) }
      it { assigns(:profiles).should =~ [user,user_gender_dance] }
      it { expect(assigns(:profiles)).not_to include(unpublished_user, user_dance) }
    end
  end


  describe "show action" do
    
    shared_examples_for "successful show action" do
      it { expect(response).to be_success }
      it { expect(response).to render_template("show") }
      it { expect(assigns(:message)).to be_kind_of(Message) }
    end
    
    context "show published profile of specific user" do
      before { get :show, id: user.id }
      it_should_behave_like "successful show action"
      it { expect(assigns(:profile)).to eq(user) }
    end

    context "show published profiles of specific user to another signed in user" do
      before { sign_in user_dance; get :show, id: user.id }
      it_should_behave_like "successful show action"
      it { expect(assigns(:profile)).to eq(user) }
    end

    context "show published profile of specific user to admin" do
      before { sign_in admin; get :show, id: user.id }
      it_should_behave_like "successful show action"
      it { expect(assigns(:profile)).to eq(user) }
    end

    context "show unpublished profile for user's own profile" do
      before { sign_in unpublished_user; get :show, id: unpublished_user.id }
      it_should_behave_like "successful show action"
      it { expect(assigns(:profile)).to eq(unpublished_user) }
    end

    context "show unpublished profile of specific user to admin" do
      before { sign_in admin; get :show, id: unpublished_user.id }
      it_should_behave_like "successful show action"
      it { expect(assigns(:profile)).to eq(unpublished_user) }
    end
    
    context "don't show unpublished profiles to unauthorized users" do
      before { get :show, id: unpublished_user.id }
      it { expect(response).to redirect_to("/de/profiles") }
    end

    context "don't show unpublished profiles to unauthorized signed in users" do
      before { sign_in user_dance; get :show, id: unpublished_user.id }
      it { expect(response).to redirect_to("/de/profiles") }
    end
  end


  describe "edit action" do
    # uses Devise::TestHelpers methods, otherwise authenticate error
    
    context "user is not signed in and shouldn't be able to edit" do  
      before { get :edit, id: user.id }    
      it { expect(response).to redirect_to(profiles_path(locale: 'de')) }
    end
    
    context "user is signed in as user_gender_dance and should be able to edit her profile" do
      before {  sign_in user_gender_dance; get :edit, id: user_gender_dance.id }
      it { expect(response).to render_template("edit") }
      it { expect(assigns(:profile)).to eq(user_gender_dance) }
    end

    context "user is signed in as user_gender_dance and should not be able to edit other users profile" do
      before {  sign_in user_gender_dance; get :edit, id: user.id }
      it { expect(response).not_to render_template("edit") }
      it { expect(response).to redirect_to(profiles_path(locale: 'de')) }
    end

    context "user is signed in as admin and should be able to edit other users profile" do
      before { sign_in admin; get :edit, id: user.id }
      it { expect(response).to render_template("edit") }
      it { expect(assigns(:profile)).to eq(user) }
    end
  end


  describe "update action" do

    context "user should not be able to update profile without sign_in" do
      before { put :update, id: user.id }
      it { expect(response).to redirect_to(profiles_path(locale: 'de')) }
    end

    context "user should update her own profile" do
       before { sign_in user; put :update, id: user.id, profile: { :bio => "newText" } }
       it { expect(response).to redirect_to(profile_path(locale: 'de', id: user.id)) }
       it { expect(assigns(:profile).bio).to eq("newText") }
    end

    context "user should not be able to update other users profile" do
      before {  sign_in user_gender_dance ; put :update, id: user.id }
      it { expect(response).to redirect_to(profiles_path(locale: 'de')) }
    end

    context "user is signed in as admin and should be able to update other users profile" do
      before { sign_in admin; put :update, id: user.id }
      it { expect(response).to redirect_to(profile_path(locale: 'de', id: user.id)) }
      it { expect(assigns(:profile)).to eq(user) }
    end
  end

end