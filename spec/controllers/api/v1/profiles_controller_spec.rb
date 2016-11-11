include AuthHelper

describe Api::V1::ProfilesController, type: :controller do
  let(:profile1) { FactoryGirl.create(:published) }
  let(:data) { JSON.parse(response.body) }

  describe 'test index action' do
    let(:profile2) { FactoryGirl.create(:published) }
    let(:unpublished_profile) { FactoryGirl.create(:profile) }

    before do
      http_login('horst', '123')
    end

    it 'should return many profiles for json request' do
      get :index, ids: [profile1.id, profile2.id], format: :json

      expect(data[0]).to include('id' => profile1.id)
      expect(data[1]).to include('id' => profile2.id)
    end

    it 'should filter published profiles by id' do
      get :index, ids: [profile1.id], format: :json

      expect(data[0]).to include('id' => profile1.id)
      expect(data[1]).to be_nil
    end

    it 'should not show unpublished profiles' do
      get :index, ids: [unpublished_profile.id], format: :json

      expect(data[0]).to be_nil
    end
  end

  describe 'show action' do
    it 'should respond to json request for one profile' do
      http_login('horst', '123')
      get :show, id: profile1.id, format: 'json'
      expect(data).to include('id' => profile1.id, 'firstname' => 'Factory', 'lastname' => 'Girl')
    end

    it 'should deny json requests without a login' do
      get :show, id: profile1.id, format: 'json'
      expect(response.status).to eq(401)
    end
  end

  describe 'text containing attributes' do
    before do
      http_login('horst', '123')
    end

    it 'should not contain attribute email' do
      get :index, ids: [profile1.id], format: :json
      expect(data).not_to include('email' => 'person1@example.com')
    end

    it 'should not contain attribute published' do
      get :index, ids: [profile1.id], format: :json
      expect(data).not_to include('published' => true)
    end

    it 'should not contain attribute admin_comment' do
      get :index, ids: [profile1.id], format: :json
      expect(data).not_to include('admin_comment' => nil)
    end
  end
end
