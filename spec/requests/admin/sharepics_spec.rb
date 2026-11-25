require 'rails_helper'

RSpec.describe 'Admin::Sharepics', type: :request do
  let(:image) { fixture_file_upload(Rails.root.join('spec/dummy.png'), 'image/png') }

  context 'as a normal profile' do
    before { sign_in create(:published_profile) }

    it 'is not allowed' do
      get admin_sharepics_path
      expect(response).to redirect_to(profiles_url(locale: I18n.locale))
    end
  end

  context 'as an admin' do
    before { sign_in create(:profile, :admin) }

    it 'lists sharepics' do
      create(:sharepic, title: 'Frauentag')
      get admin_sharepics_path
      expect(response.body).to include('Frauentag')
      expect(response.body).to include(sharepics_path(locale: I18n.locale))
    end

    it 'renders the new form' do
      get new_admin_sharepic_path(locale: I18n.locale)
      expect(response).to have_http_status(:ok)
    end

    it 'renders the edit form with the current image' do
      sharepic = create(:sharepic)
      get edit_admin_sharepic_path(sharepic.id, locale: I18n.locale)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('dummy.png')
    end

    it 'creates a sharepic' do
      expect do
        post admin_sharepics_path, params: { sharepic: { title: 'Neu', image: image } }
      end.to change(Sharepic, :count).by(1)
      expect(response).to redirect_to(admin_sharepics_path(locale: I18n.locale))
    end

    it 'renders errors for invalid input' do
      expect do
        post admin_sharepics_path, params: { sharepic: { title: '' } }
      end.not_to change(Sharepic, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'updates a sharepic' do
      sharepic = create(:sharepic)
      patch admin_sharepic_path(sharepic.id, locale: I18n.locale), params: { sharepic: { title: 'Geändert' } }
      expect(sharepic.reload.title).to eq('Geändert')
    end

    it 'deletes a sharepic' do
      sharepic = create(:sharepic)
      expect { delete admin_sharepic_path(sharepic.id, locale: I18n.locale) }.to change(Sharepic, :count).by(-1)
    end
  end
end
