# frozen_string_literal: true

describe ProfilesController, type: :controller do
  include AuthHelper

  let!(:profile_published) { create(:published_profile, topic_list: %w[ruby algorithms]) }
  let!(:profile_unpublished) { create(:unpublished_profile) }
  let!(:ada) { create(:published_profile, email: "ada@mail.org", main_topic_en: 'math') }
  let!(:admin) { create(:admin) }

  describe 'test index action' do
    before do
      get :index
    end

    it 'displays index' do
      expect(response).to be_successful
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
      get :index, params: {  search: 'ruby' }
      expect(response).to be_successful
    end

    it 'should store aggregations in aggs variable' do
      get :index, params: { search: 'ruby' }
      expect(assigns(:aggs)).to have_key(:city)
      expect(assigns(:aggs)).to have_key(:lang)
      expect(assigns(:aggs)).to have_key(:country)
    end
  end

  describe 'show profile' do
    describe 'of unpublished profile' do
      it 'is not permitted for unauthorized not signed in profile' do
        get :show, params: { id: profile_unpublished.id }
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'is not permitted for unauthorized signed in profile' do
        sign_in ada
        get :show, params: { id: profile_unpublished.id }
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end

      it 'is permitted for own profile' do
        sign_in profile_unpublished
        get :show, params: { id: profile_unpublished.id }
        expect(response).to render_template(:show)
      end

      it 'is permitted for admin' do
        sign_in admin
        get :show, params: { id: profile_unpublished.id }
        expect(response).to render_template(:show)
      end
    end

    describe 'of published profile' do
      it 'should be seen by all profiles' do
        get :show, params: { id: profile_published.id }
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'edit profile' do

    context 'when editing own profile' do
      before do
        sign_in ada
        get :edit, params: { locale: 'de', id: ada.id }
      end

      it 'renders edit view' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when trying to edit a different profile' do
      before do
        sign_in ada
        get :edit, params: { locale: 'de', id: profile_published.id }
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
        get :edit, params: { locale: 'de', id: ada.id }
      end

      it 'does not render edit view' do
        expect(response).to_not render_template(:edit)
      end

      it 'redirects to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end

    xit "doesn't create extra translations" do
      de_translation = ada.translations.create!('locale' => 'de', 'main_topic' => 'Hauptthema')
      en_translation = ada.translations.create!('locale' => 'en', 'main_topic' => 'Main topic')

      profile_params = {
        translations_attributes:
          { '0':
            {
              'locale':       'de',
              'main_topic':   'Algorithmen',
              'bio':          'Deutsche Biografie',
              'id':           de_translation.id
            },
          '1':
            {
              'locale':       'en',
              'main_topic':   'algorithms',
              'bio':          'English Bio',
              'id':           en_translation.id
            } }
      }
      patch :update, params: { id: ada.id }.merge(profile: profile_params)

      expect(ada.reload.translations.size).to eq(2)
    end
  end

  describe 'update profile action' do

    context 'when updating own profile with valid params' do
      before do
        sign_in ada
        put :update, params: { id: ada.id, profile: { firstname: 'marie', lastname: 'curie' } }
      end

      it 'updates the requested Profile' do
        ada.reload
        expect(ada.firstname).to eq 'marie'
      end

      it 'redirects to the updated profile' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles/marie-curie")
      end
    end

    context 'when invalid params are supplied' do
      before do
        sign_in ada
        put :update, params: { id: ada.id, profile: { email: ' ' } }
      end

      it 'does not update the requested Profile' do
        expect(ada.email).to eq('ada@mail.org')
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when trying to update a different profile' do
      before do
        sign_in ada
        put :update, params: { id: profile_published.id, profile: { firstname: 'marie', lastname: 'curie' } }
      end

      it 'does not update the requested profile' do
        profile_published.reload
        expect(profile_published.firstname).to eq('Susi')
      end

      it 'redirects to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end

    context 'when trying update profile if user is not signed in' do
      before do
        put :update, params: { id: profile_published.id, profile: { firstname: 'marie', lastname: 'curie' } }
      end

      it 'does not update the requested profile' do
        profile_published.reload
        expect(profile_published.firstname).to eq('Susi')
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end
  end

  describe 'destroy profile action' do

    context 'when destroying own profile' do
      before do
        sign_in ada
      end

      it 'should destroy requested profile' do
        expect do
          delete :destroy, params: { id: ada.id }
        end.to change(Profile, :count).by(-1)
      end

      it 'should not find the destroyed user' do
        delete :destroy, params: { id: ada.id }
        expect { Profile.find(ada.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it 'should redirect to profiles overview' do
        delete :destroy, params: { id: ada.id }
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end

    context 'when trying to destroy a different profile' do
      before do
        sign_in ada
        delete :destroy, params: { id: profile_published.id }
      end

      it 'should not destroy the requested profile' do
        expect(Profile.where(id: profile_published.id).count).to eq 1
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end

    context 'when trying destroy profile if user is not signed in' do
      before do
        delete :destroy, params: { id: ada.id }
      end

      it 'should not destroy the requested profile' do
        expect(Profile.where(id: ada.id).count).to eq 1
      end

      it 'should redirect to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end
  end
end
