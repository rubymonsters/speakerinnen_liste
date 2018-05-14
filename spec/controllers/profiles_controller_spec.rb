include AuthHelper

describe ProfilesController, type: :controller do
  describe 'test index action' do
    let!(:profile) do
      FactoryBot.create(:published,
                         topic_list: %w[ruby algorithms])
    end
    let!(:profile_unpublished) { FactoryBot.create(:unpublished) }
    let!(:ada) do
      FactoryBot.create(:published,
                         main_topic_en: 'first computer program',
                         bio_en:        'first female programer')
    end

    before do
      get :index
    end

    it 'displays index' do
      expect(response).to be_success
      expect(response.response_code).to eq(200)
      expect(response).to render_template('index')
    end

    it 'displays published profiles' do
      expect(assigns(:profiles)).to eq([ada])
    end

    it 'does not include unpublished profiles' do
      expect(assigns(:profiles)).not_to include(profile_unpublished)
    end
  end

  describe 'search action', elasticsearch: true do
    it 'displays search results if search term is present' do
      sleep 1
      get :index, params: { search: 'ruby' }
      expect(response).to be_success
    end

    it 'should store aggregations in aggs variable' do
      get :index, params: { search: 'ruby' }
      expect(assigns(:aggs)).to have_key(:city)
      expect(assigns(:aggs)).to have_key(:lang)
      expect(assigns(:aggs)).to have_key(:country)
    end
  end

  describe 'show profile' do
    let!(:profile) { FactoryBot.create(:unpublished) }
    let!(:profile1) { FactoryBot.create(:published) }
    let!(:admin) { FactoryBot.create(:admin) }

    describe 'of unpublished profile' do
      it 'is not permitted for unauthorized not signed in profile' do
        get :show, params: { id: profile.id }
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'is not permitted for unauthorized signed in profile' do
        sign_in profile1
        get :show, params: { id: profile.id }
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'is permitted for own profile' do
        sign_in profile
        get :show, params: { id: profile.id }
        expect(response).to render_template(:show)
      end

      it 'is permitted for admin' do
        sign_in admin
        get :show, params: { id: profile.id }
        expect(response).to render_template(:show)
      end
    end

    describe 'of published profile' do
      it 'should be seen by all profiles' do
        get :show, params: { id: profile1.id }
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'edit profile' do
    let!(:profile) { FactoryBot.create(:published) }
    let!(:profile1) { FactoryBot.create(:published) }

    context 'when editing own profile' do
      before do
        sign_in profile
        get :edit, locale: 'de', id: profile.id
      end

      it 'renders edit view' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when trying to edit a different profile' do
      before do
        sign_in profile
        get :edit, locale: 'de', id: profile1.id
      end

      it 'does not render edit view' do
        expect(response).to_not render_template(:edit)
      end

      it 'redirects to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end

    context 'when trying edit profile if user is not signed in' do
      before do
        get :edit, locale: 'de', id: profile.id
      end

      it 'does not render edit view' do
       expect(response).to_not render_template(:edit)
      end

      it 'redirects to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
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
      patch :update, params: { id: profile.id }.merge(profile: profile_params)

      expect(profile.reload.translations.size).to eq(2)
    end
  end

  describe 'update profile action' do
    let!(:profile) { FactoryBot.create(:published, email: 'factory@girl.com') }
    let!(:profile1) { FactoryBot.create(:published) }

    context 'when updating own profile with valid params' do
      before do
        sign_in profile
        put :update, id: profile.id, profile: { firstname: 'marie', lastname: 'curie' }
      end

      it 'updates the requested Profile' do
        profile.reload
        expect(profile.firstname).to eq 'marie'
      end

      it 'redirects to the updated profile' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles/marie-curie")
      end
    end

    context 'when invalid params are supplied' do
      before do
        sign_in profile
        put :update, id: profile.id, profile: { email: ' ' }
      end

      it 'does not update the requested Profile' do
        expect(profile.email).to eq('factory@girl.com')
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when trying to update a different profile' do
      before do
        sign_in profile
        put :update, id: profile1.id, profile: { firstname: 'marie', lastname: 'curie' }
      end

      it 'does not update the requested profile' do
        profile1.reload
        expect(profile1.firstname).to eq("Factory")
      end

      it 'redirects to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end

    context 'when trying update profile if user is not signed in' do
      before do
        put :update, id: profile.id, profile: { firstname: 'marie', lastname: 'curie' }
      end

      it 'does not update the requested profile' do
        profile.reload
        expect(profile1.firstname).to eq("Factory")
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end
  end

  describe 'destroy profile action' do
    let!(:profile) { FactoryBot.create(:published) }
    let!(:profile1) { FactoryBot.create(:published) }

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

      it 'should redirect to profiles overview' do
        delete :destroy, id: profile.id
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
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
    end
  end
end
