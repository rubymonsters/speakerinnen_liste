require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  describe "#new_message" do
    let(:message) do
      Message.new(
        subject: "Test Subject",
        email: "ada@example.com",
        body: "This is a test message.",
        name: "Ada Lovelace"
      )
    end

    context "when `to` is provided" do
      let(:mail) { NotificationsMailer.new_message(message, "bcc@example.com") }

      it "renders the subject" do
        expect(mail.subject).to eq("[Speakerinnen-Liste] Test Subject")
      end

      it "sends from the default email" do
        expect(mail.from).to eq(["team@speakerinnen.org"])
      end

      it "sends to no-reply@speakerinnen.org" do
        expect(mail.to).to eq(["no-reply@speakerinnen.org"])
      end

      it "includes the correct CC and BCC recipients" do
        expect(mail.cc).to eq(["ada@example.com"])
        expect(mail.bcc).to eq(["bcc@example.com"])
      end

      it "sets the reply-to field correctly" do
        expect(mail.reply_to).to eq(["ada@example.com"])
      end

      it "includes the message body in the email" do
        expect(mail.body.encoded).to match message.body
      end
    end

    context "when `to` is nil" do
      let(:mail) { NotificationsMailer.new_message(message, nil) }

      it "does not set CC, BCC, or Reply-To fields" do
        expect(mail.cc).to be_nil
        expect(mail.bcc).to be_nil
        expect(mail.reply_to).to be_nil
      end

      # happens when people contact the speakerinnen team
      it "sends to the default email" do
        expect(mail.to).to eq(["team@speakerinnen.org"])
      end
    end

    describe "email body when the locale is English" do
      before { I18n.locale = :en }
      let(:mail) { NotificationsMailer.new_message(message, nil) }

      it "renders the correct email body" do
        expect(mail.body.encoded).to include("#{message.name} contacted you via the Speakerinnen website. Here is the message:")
        expect(mail.body.encoded).to include("The name of the sender: #{message.name}")
        expect(mail.body.encoded).to include("The sender's mail address: #{message.email}")
        expect(mail.body.encoded).to include("The subject: #{message.subject}")
        expect(mail.body.encoded).to include("The message: #{message.body}")
        expect(mail.body.encoded).to include("To donate to speakerinnen.org click to the following link >>> #{donate_url}!")
      end
    end

    describe "email body when the locale is English" do
      before { I18n.locale = :de }
      let(:mail) { NotificationsMailer.new_message(message, nil) }

      it "renders the correct email body" do
        expect(mail.body.encoded).to include("#{message.name} hat dich über die Speakerinnen-Website kontaktiert. Das ist die Nachricht:")
        expect(mail.body.encoded).to include("Absender_in: #{message.name}")
        expect(mail.body.encoded).to include("Mailadresse: #{message.email}")
        expect(mail.body.encoded).to include("Der Betreff: #{message.subject}")
        expect(mail.body.encoded).to include("Die Nachricht: #{message.body}")
        expect(mail.body.encoded).to include("Spende gerne an speakerinnen.org! >>> #{donate_url}!")
      end
    end
  end
end
