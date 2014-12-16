require 'spec_helper'

describe ProfilesController, type: :controller do

  describe 'test index action' do
    let!(:profile) { FactoryGirl.create(:published) }
    let!(:profile2) { FactoryGirl.create(:user, email: 'test@anders.com') }

    before do
      get :index
    end

    it 'should display index' do
      expect(response).to be_success
      expect(response.response_code).to eq(200)
      expect(response).to render_template('index')
    end

    it 'should display profiles' do
      expect(assigns(:profiles)).to eq([profile])
    end

    it 'should not include unpublished profiles' do
      expect(assigns(:profiles)).not_to include(profile2)
    end
  end

  describe 'show profile' do
    let!(:profile) { FactoryGirl.create(:unpublished) }
    let!(:profile1) { FactoryGirl.create(:published, email: 'test@anders.com') }
    let!(:admin) { FactoryGirl.create(:admin, email: 'admin@anders.com') }

    describe 'of unpublished profile' do
      it 'is not permited for unauthorized not signed in profile' do
        get :show, id: profile.id
        expect(response).to redirect_to('/de/profiles')
      end

      it 'is not permited for unauthorized signed in profile' do
        sign_in profile1
        get :show, id: profile.id
        expect(response).to redirect_to('/de/profiles')
      end

      it 'is permited for own profile' do
        sign_in profile
        get :show, id: profile.id
        expect(response).to render_template(:show)
      end

      it 'is permited for admin' do
        sign_in admin
        get :show, id: profile.id
        expect(response).to render_template(:show)
      end
    end

    describe 'of published profile' do
      it 'should be seen by all profiles' do
        get :show, id: profile1.id
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'edit profile' do
    let!(:maren) { FactoryGirl.create(:published) }

    before do
      sign_in maren
    end

    it "doesn't create extra translations" do
      controller.build_missing_translations(maren)
      profile_params = { :translations_attributes =>
        {'0'=>{'locale'=>'de',
              'main_topic'=>'Soziale Medien',
              'bio'=>'Dingsbums',
              'id'=>'12'},
              '1'=>{'locale'=>'de',
              'main_topic'=>'Medien und so',
              'bio'=>'Dingsbums',
              'id'=>'95'}
        }
      }
      patch :update, {id: maren.id}.merge(profile: profile_params)
      expect(profile)
    end
  end
end
