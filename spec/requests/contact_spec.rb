require 'rails_helper'

RSpec.describe "ContactController", type: :request do
  let(:valid_params) do
    {
      message: {
        name: "Alice",
        email: "alice@example.org",
        subject: "Hello",
        body: "Test message"
      }
    }
  end
  let(:profile) { create(:published_profile) }

  describe "GET /contact" do
    context "without profile ID" do
      it "renders the contact form ( contact the team )" do
        get contact_path
        expect(response).to be_successful
        expect(response.body).to include("form") 
      end
    end

    context "with profile ID" do
      it "loads the profile and renders the form" do
        get contact_path(id: profile.slug)
        expect(response).to be_successful
        expect(assigns(:profile)).to eq(profile)
      end
    end
  end

  describe "POST /contact" do
    context "with published profile" do
      it "sends messages and redirects to profile path" do
        expect {
          post contact_path, params: valid_params.merge(id: profile.slug)
        }.to change { ActionMailer::Base.deliveries.count }.by(2)

        expect(response).to redirect_to(profile_path(profile))
      end
    end

    context "with no profile (contacting team)" do
      it "sends message to team and redirects to root path" do
        expect {
          post contact_path, params: valid_params
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to(root_path)
      end
    end

    context "with inactive profile" do


      it "redirects to profiles page with a flash notice" do
        profile.update(inactive: true)
        expect {
          post contact_path, params: valid_params.merge(id: profile.slug)
        }.not_to change { ActionMailer::Base.deliveries.count }

        expect(response).to redirect_to(profiles_url)
      end
    end

    context "with spam email in ENV list" do
      before { stub_const('ENV', ENV.to_hash.merge('FISHY_EMAILS' => 'alice@example.org')) }

      it "does not send mail and behaves like it did sent the email" do
        expect {
          post contact_path, params: valid_params.merge(id: profile.slug)
        }.not_to change { ActionMailer::Base.deliveries.count }

        expect(response).to redirect_to(profile_path(profile))
        end
    end

    context "with invalid message params" do
      it "re-renders the form with errors" do
        post contact_path, params: {:message=>{:name=>"", :email=>"alice@example.org", :subject=>"Hello", :body=>"Test message"} }

        expect(response).to render_template(:new)
        expect(response.body).to include(I18n.t('contact.form.error_email_for_us'))
      end
    end

    context "with invisible captcha triggered (spam)" do
      it "redirects to root path via spam callback" do
        allow_any_instance_of(ContactController).to receive(:invisible_captcha?).and_return(true)

        post contact_path, params: valid_params.merge(nickname: 'bot')
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invisible captcha not triggered" do
      it "processes the form normally" do
        allow_any_instance_of(ContactController).to receive(:invisible_captcha?).and_return(false)

        post contact_path, params: valid_params
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t('contact.form.notice'))
      end
    end

    context "cookie consent" do
      it 'does not show contact button without cookie consent' do
        visit profile_path(id: profile.slug)
        expect(page).not_to have_button(I18n.t('contact.form.send'))
      end
      it 'shows contact button with cookie consent' do
        visit profile_path(id: profile.slug)
        find_link(class: 'cookie-consent').click
        expect(page).to have_button(I18n.t('contact.form.send'))
      end
      it 'opens contact modal when cookie consent is given' do
        visit profile_path(id: profile.slug)
        find_link(class: 'cookie-consent').click
        find("button[data-target='#contactModal']", match: :first).click
        expect(page).to have_selector('#contactModal', visible: true)
      end
    end
  end
end
