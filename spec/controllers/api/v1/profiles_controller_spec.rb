require 'spec_helper'
include AuthHelper

describe Api::V1::ProfilesController, type: :controller do
  let!(:profile1) { FactoryGirl.create(:published) }

  describe 'test index action' do
    let!(:profile2) { FactoryGirl.create(:published, email: 'Maria@example.com') }
    let!(:unpublished_profile) { FactoryGirl.create(:profile, email: 'Peter@example.com') }

    before do
      http_login("horst", "123")
    end

    it 'should return many profiles for json request' do
      get :index, ids: [profile1.id, profile2.id], format: :json

      expect(response.body).to include('{"id":' + profile1.id.to_s + ',"firstname"')
      expect(response.body).to include('{"id":' + profile2.id.to_s + ',"firstname"')
    end

    it 'should filter published profiles by id' do
      get :index, ids: [profile1.id], format: :json

      expect(response.body).to include('{"id":' + profile1.id.to_s + ',"firstname"')
      expect(response.body).not_to include('{"id":' + profile2.id.to_s + ',"firstname"')
    end

    it 'should not show unpublished profiles' do
      get :index, ids: [unpublished_profile.id], format: :json

      expect(response.body).to eq "[]"
    end
  end

  describe 'show action' do
    it 'should respond to json request for one profile' do
      http_login("horst", "123")
      get :show, id: profile1.id, format: "json"
      expect(response.body).to include('{"id":' + profile1.id.to_s + ',"firstname":"Factory","lastname":"Girl"')
    end

    it 'should deny json requests without a login' do
      get :show, id: profile1.id, format: "json"
      expect(response.status).to eq(401)
    end
  end
end
