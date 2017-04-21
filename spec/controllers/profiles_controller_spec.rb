include AuthHelper

describe ProfilesController, type: :controller do
  describe 'test index action' do
    let!(:profile) { FactoryGirl.create(:published, topic_list: ['ruby', 'algorithms']) }
    let!(:profile2) { FactoryGirl.create(:profile) }
    let!(:ada) { Profile.create!(FactoryGirl.attributes_for(:published,
                    translations_attributes:
                      { '0':
                        { 'locale':       'en',
                          'main_topic':   'first computer program',
                          'bio':          'first female programer' }
                        })) }

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
      expect(assigns(:profiles)).not_to include(profile2)
    end
  end

  describe 'search action', elasticsearch: true do
    it 'should display search results if search term is present' do
      sleep 1
      get :index, {:search => 'ruby'}
      expect(response).to be_success
    end

    it 'should store aggregations in aggs variable' do
      get :index, {:search => 'ruby'}
      expect(assigns :aggs).to have_key(:city)
      expect(assigns :aggs).to have_key(:lang)
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

  describe 'edit profile' do
    let!(:profile) { FactoryGirl.create(:published) }

    before do
      sign_in profile
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
            }
            }
      }
      patch :update, { id: profile.id }.merge(profile: profile_params)

      expect(profile.reload.translations.size).to eq(2)
    end
  end
end
