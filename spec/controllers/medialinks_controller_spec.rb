# frozen_string_literal: true

include AuthHelper

describe ProfilesController, type: :controller do
  let!(:ada) do
    FactoryBot.create(:published,
                      firstname: 'Ada',
                      lastname: 'Lovelace',
                      email: 'ada@lovelace.de',
                      twitter: '@alove',
                      main_topic_en: 'first computer programm',
                      bio_en: 'first programmer',
                      city_en: 'London',
                      country: 'GB',
                      iso_languages: %w[en fr],
                      topic_list: 'algorithm, mathematic')
  end
  let!(:ada_medialink) do
    FactoryBot.create(:medialink,
                      profile_id: ada.id,
                      title: 'Ada and the computer',
                      url: 'www.adalovelace.de',
                      description: 'How to program',
                      language: 'en')
  end

  before do
    sign_in ada
    get :edit, params: { id: ada.id }
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

    it 'should be able to add language' do
      expect(ada_medialink.language).to eq('en')
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
