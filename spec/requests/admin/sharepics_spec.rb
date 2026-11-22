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
    end

    it 'creates a sharepic' do
      expect {
        post admin_sharepics_path, params: { sharepic: { title: 'Neu', image: image } }
      }.to change(Sharepic, :count).by(1)
      expect(response).to redirect_to(admin_sharepics_path(locale: I18n.locale))
    end

    it 'renders errors for invalid input' do
      expect {
        post admin_sharepics_path, params: { sharepic: { title: '' } }
      }.not_to change(Sharepic, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'updates a sharepic' do
      sharepic = create(:sharepic)
      patch admin_sharepic_path(sharepic), params: { sharepic: { title: 'Geändert' } }
      expect(sharepic.reload.title).to eq('Geändert')
    end

    it 'deletes a sharepic' do
      sharepic = create(:sharepic)
      expect { delete admin_sharepic_path(sharepic) }.to change(Sharepic, :count).by(-1)
    end
  end
end
