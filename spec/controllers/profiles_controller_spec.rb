include AuthHelper

describe ProfilesController, type: :controller do
  describe 'test index action' do
    let!(:profile) do
      FactoryGirl.create(:published,
                         topic_list: %w[ruby algorithms])
    end
    let!(:profile_unpublished) { FactoryGirl.create(:unpublished) }
    let!(:ada) do
      FactoryGirl.create(:published,
                         main_topic_en: 'first computer program',
                         bio_en:        'first female programer')
    end

    before do
      get :index
    end

    it 'should display index' do
      expect(response).to be_success
      expect(response.response_code).to eq(200)
      expect(response).to render_template('index')
    end

    it 'should display published profiles' do
      expect(assigns(:profiles)).to eq([ada])
    end

    it 'should not include unpublished profiles' do
      expect(assigns(:profiles)).not_to include(profile_unpublished)
    end
  end

  describe 'search action', elasticsearch: true do
    it 'should display search results if search term is present' do
      sleep 1
      get :index, search: 'ruby'
      expect(response).to be_success
    end

    it 'should store aggregations in aggs variable' do
      get :index, search: 'ruby'
      expect(assigns(:aggs)).to have_key(:city)
      expect(assigns(:aggs)).to have_key(:lang)
      expect(assigns(:aggs)).to have_key(:country)
    end
  end

  describe 'show profile' do
    let!(:profile) { FactoryGirl.create(:unpublished) }
    let!(:profile1) { FactoryGirl.create(:published) }
    let!(:admin) { FactoryGirl.create(:admin) }

    describe 'of unpublished profile' do
      it 'is not permitted for unauthorized not signed in profile' do
        get :show, id: profile.id
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'is not permitted for unauthorized signed in profile' do
        sign_in profile1
        get :show, id: profile.id
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'is permitted for own profile' do
        sign_in profile
        get :show, id: profile.id
        expect(response).to render_template(:show)
      end

      it 'is permitted for admin' do
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

  describe 'edit profile action' do
    let!(:profile) { FactoryGirl.create(:published) }
    let!(:profile1) { FactoryGirl.create(:published) }

    context 'when editing own profile' do
      before do
        sign_in profile
        get :edit, locale: 'de', id: profile.id
      end

      it 'should render edit view' do
        expect(response).to render_template(:edit)
      end

      it 'should return a 200 status response' do
        expect(response.status).to eq 200
      end
    end

    context 'when trying to edit a different profile' do
      before do
        sign_in profile
        get :edit, locale: 'de', id: profile1.id
      end

      it 'should not render edit view' do
        expect(response).to_not render_template(:edit)
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'should return a 302 status response' do
        expect(response.status).to eq 302
      end
    end

    context 'when trying edit profile if user is not signed in' do
      before do
        get :edit, locale: 'de', id: profile.id
      end

      it 'should not render edit view' do
       expect(response).to_not render_template(:edit)
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'should return a 302 status response' do
        expect(response.status).to eq 302
      end
    end

    it "doesn't create extra translations" do
      de_translation = profile.translations.create!('locale' => 'de', 'main_topic' => 'Hauptthema')
      en_translation = profile.translations.create!('locale' => 'en', 'main_topic' => 'Main topic')

      profile_params = {
        translations_attributes:
          { '0':
            {
              'locale':       'de',
              'main_topic':   'Soziale Medien',
              'bio':          'Deutsche Biografie',
              'id':           de_translation.id
            },
          '1':
            {
              'locale':       'en',
              'main_topic':   'Social Media',
              'bio':          'English Bio',
              'id':           en_translation.id
            } }
      }
      patch :update, { id: profile.id }.merge(profile: profile_params)

      expect(profile.reload.translations.size).to eq(2)
    end
  end

  describe 'update profile action' do
    let!(:profile) { FactoryGirl.create(:published) }
    let!(:profile1) { FactoryGirl.create(:published) }

    context 'when updating own profile' do
      before do
        sign_in profile
        put :update, id: profile.id, profile: { firstname: 'marie', lastname: 'curie' }
      end

      it 'should update the requested Profile' do
        profile.reload
        expect(profile.firstname).to eq 'marie'
      end

      it 'should redirect to the updated profile' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles/marie-curie")
      end

      it 'should return a 302 status response' do
        expect(response.status).to eq 302
      end
    end

    context 'when trying to update a different profile' do
      before do
        sign_in profile
        put :update, id: profile1.id, profile: { firstname: 'marie', lastname: 'curie' }
      end

      it 'should not update the requested profile' do
        profile1.reload
        expect(profile1.firstname).to eq("Factory")
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'should return a 302 status response' do
        expect(response.status).to eq 302
      end
    end

    context 'when trying update profile if user is not signed in' do
      before do
        put :update, id: profile.id, profile: { firstname: 'marie', lastname: 'curie' }
      end

      it 'should not update the requested profile' do
        profile.reload
        expect(profile1.firstname).to eq("Factory")
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'should return a 302 status response' do
        expect(response.status).to eq 302
      end
    end
  end

  describe 'destroy profile action' do
    let!(:profile) { FactoryGirl.create(:published) }
    let!(:profile1) { FactoryGirl.create(:published) }

    context 'when destroying own profile' do
      before do
        sign_in profile
      end

      it 'should destroy requested profile' do
        expect do
          delete :destroy, id: profile.id
        end.to change(Profile, :count).by(-1)
      end

      it 'should not find the destroyed user' do
        delete :destroy, id: profile.id
        expect { Profile.find(profile.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it 'should redirect to the updated profile' do
        delete :destroy, id: profile.id
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'should return a 302 status response' do
        delete :destroy, id: profile.id
        expect(response.status).to eq 302
      end
    end

    context 'when trying to destroy a different profile' do
      before do
        sign_in profile
        delete :destroy, id: profile1.id
      end

      it 'should not destroy the requested profile' do
        expect(Profile.where(id: profile1.id).count).to eq 1
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'should return a 302 status response' do
        expect(response.status).to eq 302
      end
    end

    context 'when trying destroy profile if user is not signed in' do
      before do
        delete :destroy, id: profile.id
      end

      it 'should not destroy the requested profile' do
        expect(Profile.where(id: profile.id).count).to eq 1
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'should return a 302 status response' do
        expect(response.status).to eq 302
      end
    end
  end
end
