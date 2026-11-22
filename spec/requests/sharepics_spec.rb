require 'rails_helper'

RSpec.describe 'Sharepics', type: :request do
  let!(:sharepic) { create(:sharepic, title: 'Frauentag') }
  let!(:hidden) { create(:sharepic, title: 'Entwurf', published: false) }
  let(:profile) { create(:published_profile) }

  context 'when logged out' do
    it 'redirects the index to the login' do
      get sharepics_path(locale: I18n.locale)
      expect(response).to redirect_to(%r{/profiles/sign_in})
    end

    it 'does not allow downloads' do
      get download_sharepic_path(sharepic.id, locale: I18n.locale)
      expect(response).to redirect_to(%r{/profiles/sign_in})
    end
  end

  context 'when logged in' do
    before { sign_in profile }

    it 'lists published sharepics only' do
      get sharepics_path(locale: I18n.locale)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Frauentag')
      expect(response.body).not_to include('Entwurf')
    end

    it 'redirects the download to the attachment' do
      get download_sharepic_path(sharepic.id, locale: I18n.locale)
      expect(response).to have_http_status(:found)
      expect(response.location).to include('/rails/active_storage/blobs/')
      expect(response.location).to include('dummy.png')
      expect(response.location).to include('disposition=attachment')
    end

    it 'does not download unpublished sharepics' do
      get download_sharepic_path(hidden.id, locale: I18n.locale)
      expect(response).to have_http_status(:not_found)
    end
  end
end
