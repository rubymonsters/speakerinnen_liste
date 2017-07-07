# skip this test until API V2 is built
# include AuthHelper

# describe Api::V1::ProfilesController, type: :controller do
#   let(:profile1) { FactoryGirl.create(:published, twitter: 'factorygirl', city: 'New York', country: 'Unicornland') }
#   let(:data) { JSON.parse(response.body) }

#   describe 'test index action' do
#     let(:profile2) { FactoryGirl.create(:published) }
#     let(:unpublished_profile) { FactoryGirl.create(:profile) }

#     before do
#       http_login('horst', '123')
#     end

#     it 'should return many profiles for json request' do
#       get :index, ids: [profile1.id, profile2.id], format: :json

#       expect(data[0]).to include('id' => profile1.id)
#       expect(data[1]).to include('id' => profile2.id)
#     end

#     it 'should filter published profiles by id' do
#       get :index, ids: [profile1.id], format: :json

#       expect(data[0]).to include('id' => profile1.id)
#       expect(data[1]).to be_nil
#     end

#     it 'should not show unpublished profiles' do
#       get :index, ids: [unpublished_profile.id], format: :json
#       expect(data[0]).to be_nil
#     end
#   end

#   describe 'show action' do
#     it 'should respond to json request for one profile' do
#       http_login('horst', '123')
#       get :show, id: profile1.id, format: 'json'
#       expect(data).to include('id' => profile1.id, 'firstname' => 'Factory', 'lastname' => 'Girl')
#     end

#     it 'should deny json requests without a login' do
#       get :show, id: profile1.id, format: 'json'
#       expect(response.status).to eq(401)
#     end
#   end

#   describe 'containing attributes' do
#     before do
#       http_login('horst', '123')
#     end

#     it 'should contain attribute id' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['id']).to eq(profile1.id)
#     end

#     it 'should contain attribute firstname' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['firstname']).to eq('Factory')
#     end

#     it 'should contain attribute lastname' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['lastname']).to eq('Girl')
#     end

#     it 'should contain attribute city' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['city']).to eq('New York')
#     end

#     it 'should contain attribute country' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['country']).to eq('Unicornland')
#     end

#     it 'should contain attribute twitter' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['twitter']).to eq('factorygirl')
#     end

#     it 'should contain attribute picture' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['picture']).to eq(nil)
#     end

#     it 'should contain attribute created_at' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['created_at']).to eq(profile1.created_at.as_json)
#     end

#     it 'should contain attribute updated_at' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['updated_at']).to eq(profile1.updated_at.as_json)
#     end

#     it 'should contain attribute medialinks' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['medialinks']).to eq([])
#     end

#     it 'should contain attribute main_topic' do
#       get :index, ids: [profile1.id], format: :json
#       p data[0]['main_topic'][I18n.locale]
#       expect(data[0]['main_topic']).to eq({})
#     end

#     it 'should contain attribute bio' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['bio']).to eq({})
#     end

#     it 'should contain attribute topics' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data[0]['topics']).to eq([])
#     end

#     it 'should not contain attribute email' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data).not_to include('email' => 'person4@example.com')
#     end

#     it 'should not contain attribute published' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data).not_to include('published' => true)
#     end

#     it 'should not contain attribute admin_comment' do
#       get :index, ids: [profile1.id], format: :json
#       expect(data).not_to include('admin_comment' => nil)
#     end
#   end
# end
