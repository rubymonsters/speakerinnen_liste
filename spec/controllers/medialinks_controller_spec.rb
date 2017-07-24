include AuthHelper

describe ProfilesController, type: :controller do
  let!(:ada) { Profile.create!(FactoryGirl.attributes_for(:published,
                                                          firstname: 'Ada',
                                                          lastname: 'Lovelace',
                                                          email: 'ada@lovelace.de',
                                                          twitter: '@alove',
                                                          main_topic: 'first computer programm',
                                                          bio: 'first programmer',
                                                          city_en: 'London',
                                                          country: 'GB',
                                                          iso_languages: ['en', 'fr'],
                                                          topic_list: 'algorithm, mathematic'
                                                                    )) }
  let!(:ada_medialink) { FactoryGirl.create(:medialink, profile_id: ada.id,
                                                        title: 'Ada and the computer',
                                                        url: 'www.adalovelace.de',
                                                        description: 'How to program')}

  before do
    sign_in ada
    get :edit, id: ada.id
  end

  describe 'test update action' do
    it 'should render edit view' do
      expect(response).to render_template(:edit)
    end

    it 'should be able to update title' do
      expect(ada_medialink.title).to eq('Ada and the computer')
      ada_medialink.title = 'Ada and mathematics'
      expect(ada_medialink.title).to eq('Ada and mathematics')
    end

    it 'should be able to update url' do
      expect(ada_medialink.url).to eq('www.adalovelace.de')
      ada_medialink.url = 'www.adalovelace.com'
      expect(ada_medialink.url).to eq('www.adalovelace.com')
    end

    it 'should be able to update description' do
      expect(ada_medialink.description).to eq('How to program')
      ada_medialink.description = 'How to programm and to use logic'
      expect(ada_medialink.description).to eq('How to programm and to use logic')
    end
  end

  describe 'test destroy action' do
    it 'should delete destroyed medialinks' do
      expect(ada.medialinks.count).to eq(1)
      ada_medialink.destroy
      expect(ada.medialinks.count).to eq(0)
    end
  end
end
