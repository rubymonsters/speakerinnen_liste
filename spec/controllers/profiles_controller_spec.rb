# frozen_string_literal: true

describe ProfilesController, type: :controller do
  include AuthHelper
  let!(:profile_published) { create(:published_profile, topic_list: %w[ruby algorithms]) }
  let!(:profile_unpublished) { create(:unpublished_profile) }
  let!(:ada) { create(:published_profile, email: "ada@mail.org", main_topic_en: 'math') }
  let!(:admin) { create(:admin) }

  describe 'index' do
    before do
      get :index
    end

    it 'displays index template' do
      expect(response).to be_successful
      expect(response.response_code).to eq(200)
      expect(response).to render_template('index')
    end

    it 'displays published profiles' do
      expect(assigns(:records).pluck(:id)).to eq ([ada.id])
    end

    it 'does not include unpublished profiles' do
      expect(assigns(:profiles)).not_to include(profile_unpublished)
    end
  end

  describe '#search_with_category_id' do
    it 'stores the correct category when params has category id' do
      category = FactoryBot.create(:category, name: 'Seasons', name_en: 'Seasons')
      get :index, params: { category_id: category.id }
      expect(assigns(:category)).to eq(category)
    end
  end

  describe '#search_with_tags' do
    it 'redirects to profile index when tags filter is empty' do
      get :index, params: { tag_filter: "" }
      expect(response).to redirect_to("/#{I18n.locale}/profiles#top")
    end
  end

  describe '#search_with_search_params' do
    it 'displays search results if search term is present' do
      sleep 1
      get :index, params: { search: 'ruby' }
      expect(response).to be_successful
    end

    it 'should store aggregations in aggs variables' do
      get :index, params: { search: 'ruby' }
      expect(assigns(:aggs_cities)).to eq({})
      expect(assigns(:aggs_languages)).to eq({})
      expect(assigns(:aggs_countries)).to eq nil
      expect(assigns(:aggs_states)).to eq nil
    end
  end

  describe 'show' do
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

  describe '#edit' do
    context 'own profile' do
      before do
        sign_in ada
        get :edit, params: { locale: 'de', id: ada.id }
      end

      it 'renders edit view' do
        expect(response).to render_template(:edit)
      end
    end

    context "other people's profile" do
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

    context 'own profile but not signed in' do
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

  describe '#update' do
    context 'with valid params' do
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

    context 'with invalid params' do
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

    context "other people's profile" do
      before do
        sign_in ada
        put :update, params: { id: profile_published.id, profile: { firstname: 'marie', lastname: 'curie' } }
      end

      it 'does not update' do
        profile_published.reload
        expect(profile_published.firstname).to eq('Susi')
      end

      it 'redirects to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end

    context 'when user is not signed in' do
      before do
        put :update, params: { id: profile_published.id, profile: { firstname: 'marie', lastname: 'curie' } }
      end

      it 'does not update' do
        profile_published.reload
        expect(profile_published.firstname).to eq('Susi')
      end

      it 'redirects to profiles overview' do
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end
  end

  describe '#destroy' do
    context 'own profile' do
      before do
        sign_in ada
      end

      it 'should destroy profile' do
        expect do
          delete :destroy, params: { id: ada.id }
        end.to change(Profile, :count).by(-1)
      end

      it 'should not find the destroyed profile' do
        delete :destroy, params: { id: ada.id }
        expect { Profile.find(ada.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it 'should redirect to profiles overview' do
        delete :destroy, params: { id: ada.id }
        expect(response).to redirect_to("/#{I18n.locale}/profiles")
      end
    end

    context "other people's profile" do
      before do
        sign_in ada
        delete :destroy, params: { id: profile_published.id }
      end

      it 'should not destroy' do
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

  context "pagination with multiple profiles" do
    it 'displays no profiles on index page 2' do
      published_profiles = create_list(:published_profile, 23, main_topic_en: 'math')
      get :index, params: { page: 1 }
      # we have with previous created profile 24 in total
      expect(assigns(:records).count).to eq 24
      expect(assigns(:records).to_a).to match_array(published_profiles << ada)
      get :index, params: { page: 2 }
      expect(assigns(:records).count).to eq 0
    end

    it 'displays no profiles twice on index page 2' do
      create_list(:published_profile, 25, main_topic_en: 'math')

      get :index, params: { page: 1 }
      expect(assigns(:records).count).to eq 24
      profiles_page_1 = assigns(:records)

      get :index, params: { page: 2 }
      expect(assigns(:records).count).to eq 2
      profiles_page_2 = assigns(:records)
      expect(profiles_page_2 & profiles_page_1).to eq []
    end

    it 'order by last created' do
      published_profiles = create_list(:published_profile, 23, main_topic_en: 'math')
      last_created_profile = published_profiles.last
      get :index, params: { page: 1 }
      expect(assigns(:records).first).to eq last_created_profile
    end
  end
end
