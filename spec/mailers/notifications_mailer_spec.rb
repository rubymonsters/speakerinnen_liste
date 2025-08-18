require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  describe "#new_message" do
    let(:message) do
      Message.new(
        subject: "Test Subject",
        email: "radio@example.org",
        body: "This is a test message.",
        name: "Frau Radiosprecherin"
      )
    end

    describe "contact_message" do
      it 'sends a message to the speakerin in German' do
        mail = NotificationsMailer.contact_message(message, "speakerin@example.org")
        expect(mail.subject).to eq("Neue Anfrage über Speakerinnen.org: #{message.subject}")
        expect(mail.from).to eq(["team@speakerinnen.org"])
        expect(mail.to).to eq(["speakerin@example.org"])
        expect(mail.reply_to).to eq(["radio@example.org"])
        expect(mail.body.encoded).to include("du hast eine neue Kontaktanfrage von Frau Radiosprecherin über Speakerinnen.org erhalten")
        expect(mail.body.encoded).to include("Absender_in: Frau Radiosprecherin")
        expect(mail.body.encoded).to include("Mailadresse: radio@example.org")
        expect(mail.body.encoded).to include("Betreff:")
        expect(mail.body.encoded).to include("Test Subject")
        expect(mail.body.encoded).to include("This is a test message.")
        expect(mail.body.encoded).to include("Wenn du unsere gemeinnützige Arbeit unterstützen möchtest, freuen wir uns über eine Spende:")
        expect(mail.body.encoded).to include("Folge uns auf Social Media:")
      end

      it 'sends a message to the speakerin in English' do
        I18n.locale = :en
        mail = NotificationsMailer.contact_message(message, "speakerin@example.org")
        expect(mail.subject).to eq("New request via Speakerinnen.org: #{message.subject}")
        expect(mail.from).to eq(["team@speakerinnen.org"])
        expect(mail.to).to eq(["speakerin@example.org"])
        expect(mail.reply_to).to eq(["radio@example.org"])
        expect(mail.body.encoded).to include("you've received a new contact request from Frau Radiosprecherin through Speakerinnen.org:")
        expect(mail.body.encoded).to include("The name of the sender: Frau Radiosprecherin")
        expect(mail.body.encoded).to include("The sender's mail address: radio@example.org")
        expect(mail.body.encoded).to include("subject:")
        expect(mail.body.encoded).to include("Test Subject")
        expect(mail.body.encoded).to include("This is a test message.")
        expect(mail.body.encoded).to include("If you’d like to support our non-profit work, we appreciate your donation:")
        expect(mail.body.encoded).to include("Follow us on social media:")
      end

      it 'sends the message to the team@speakerinnen.org when the speakerin email is nil' do
        mail = NotificationsMailer.contact_message(message, "team@speakerinnen.org")
        expect(mail.subject).to eq("Neue Anfrage über Speakerinnen.org: #{message.subject}")
        expect(mail.from).to eq(["team@speakerinnen.org"])
        expect(mail.to).to eq(["team@speakerinnen.org"])
        expect(mail.reply_to).to eq(["radio@example.org"])
        expect(mail.body.encoded).to include("du hast eine neue Kontaktanfrage von Frau Radiosprecherin über Speakerinnen.org erhalten")

      end
    end

    describe "copy_to_sender" do
      it 'sents a copy to the sender in german' do
        mail = NotificationsMailer.copy_to_sender(message, "Ada Lovelace")
        expect(mail.subject).to eq("Bestätigung: Deine Anfrage an Ada Lovelace")
        expect(mail.from).to eq(["team@speakerinnen.org"])
        expect(mail.to).to eq(["radio@example.org"])
        expect(mail.body.encoded).to include("du hast eine neue Kontaktanfrage an Ada Lovelace über Speakerinnen.org gesendet.")
        expect(mail.body.encoded).to include("Absender_in: Frau Radiosprecherin")
        expect(mail.body.encoded).to include("Mailadresse: radio@example.org")
        expect(mail.body.encoded).to include("Betreff:")
        expect(mail.body.encoded).to include("Test Subject")
        expect(mail.body.encoded).to include("This is a test message.")
        expect(mail.body.encoded).to include("Wenn du unsere gemeinnützige Arbeit unterstützen möchtest, freuen wir uns über eine Spende")
        expect(mail.body.encoded).to include("Folge uns auf Social Media:")
      end

      it 'sends a copy to the sender in English' do
        I18n.locale = :en
        mail = NotificationsMailer.copy_to_sender(message, "Ada Lovelace")
        expect(mail.subject).to eq("Copy of your message to Speakerinnen.org")
        expect(mail.from).to eq(["team@speakerinnen.org"])
        expect(mail.to).to eq(["radio@example.org"])
        expect(mail.body.encoded).to include("You have sent a new contact request to Ada Lovelace via Speakerinnen.org.")
        expect(mail.body.encoded).to include("The name of the sender: Frau Radiosprecherin")
        expect(mail.body.encoded).to include("The sender's mail address: radio@example.org")
        expect(mail.body.encoded).to include("subject:")
        expect(mail.body.encoded).to include("Test Subject")
        expect(mail.body.encoded).to include("This is a test message.")
        expect(mail.body.encoded).to include("If you’d like to support our non-profit work, we appreciate your donation:")
        expect(mail.body.encoded).to include("Follow us on social media:")
      end
    end
  end
end
