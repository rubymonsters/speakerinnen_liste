require 'rails_helper'

RSpec.describe "Admin::BlockedEmails", type: :request do
  let!(:blocked_email) { create(:blocked_email) }
  let(:admin) { create(:profile, :admin) }

  before do
    sign_in admin
  end

  describe "GET /admin/blocked_emails" do
    it "renders the index page with blocked emails" do
      get admin_blocked_emails_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(blocked_email.contacted_profile_email)
    end
  end

  describe "GET /admin/blocked_emails/:id" do
    it "shows the blocked email" do
      get admin_blocked_email_path(blocked_email.id, locale: I18n.default_locale)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(blocked_email.body)
    end
  end

  describe "POST /admin/blocked_emails/:id/send_email" do
    it "updates sent_at and sends notifications to the speaker and to the admin" do
      expect {
        post send_email_admin_blocked_email_path(blocked_email.id, locale: I18n.default_locale)
      }.to change { ActionMailer::Base.deliveries.size }.by(2)

      blocked_email.reload
      expect(blocked_email.sent_at).not_to be_nil
      expect(response).to redirect_to(admin_blocked_email_path(blocked_email))
      expect(ActionMailer::Base.deliveries.count).to eq 2
      expect(flash[:notice]).to eq(I18n.t('contact.form.notice'))
    end
  end
end
