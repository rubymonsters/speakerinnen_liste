# frozen_string_literal: true

RSpec.describe ImageController, type: :controller do
  include AuthHelper

  let!(:profile) { create(:profile) }

  describe "DELETE #destroy" do
    xit "destroys the requested image" do
      profile.image.attach(io: File.open(Rails.root + "spec/dummy.png"), filename: 'dummy.png', content_type: 'image')
      delete :destroy, params: {id: profile.image.id}
      profile.reload
      expect(profile.image.attached?).to be false
    end
  end

end
