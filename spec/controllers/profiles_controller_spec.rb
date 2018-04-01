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
end
