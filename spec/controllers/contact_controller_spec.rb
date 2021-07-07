# frozen_string_literal: true

describe ContactController, type: :controller do
  include AuthHelper

  let!(:ada) { create(:published_profile, email: "ada@mail.org", main_topic_en: 'math') }

  describe 'create action' do
    it 'when profile active' do
      get :create, params: { id: ada.id, message: { name: "Maxi"} }
      expect(response).to be_successful
      expect(response.response_code).to eq(200)
    end

    it 'when profile inactive' do
      ada.update!(inactive: true)
      get :create, params: { id: ada.id, message: { name: "Maxi"} }
      expect(response).not_to be_successful
      expect(response.response_code).to eq(302)
      expect(response).to redirect_to("/#{I18n.locale}/profiles")
    end

    it 'when unpublished profiles' do
      ada.update!(published: false)
      get :create, params: { id: ada.id, message: { name: "Maxi"} }
      expect(response).not_to be_successful
      expect(response.response_code).to eq(302)
      expect(response).to redirect_to("/#{I18n.locale}/profiles")
    end
  end
end

