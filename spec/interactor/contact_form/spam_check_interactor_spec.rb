require 'rails_helper'

RSpec.describe ContactForm::SpamCheckInteractor do
  subject(:result) { described_class.call(message: message) }

  let(:message) do
    Message.new(
      name: 'Otto Organizer',
      email: email,
      subject: subject_text,
      body: body_text
    )
  end

  let(:email)        { 'otto@example.com' }
  let(:subject_text) { 'Hi' }
  let(:body_text)    { 'Wir suchen eine Speakerin.' }

  before do
    allow(OffensiveTerm).to receive(:pluck).and_return([])
    allow(ENV).to receive(:fetch)
      .with('FISHY_EMAILS', '')
      .and_return('')
  end

  describe 'non-spam message' do
    it 'does not mark message as spam' do
      expect(result.spam).to be false
      expect(result.reason).to be_nil
    end
  end

  describe 'spam email address' do
    let(:email) { 'spam@example.com' }

    before do
      allow(ENV).to receive(:fetch)
        .with('FISHY_EMAILS', '')
        .and_return('spam@example.com')
    end

    it 'marks message as spam with correct reason' do
      expect(result.spam).to be true
      expect(result.reason).to eq('Spam email')
    end
  end

  describe 'offensive content' do
    before do
      allow(OffensiveTerm).to receive(:pluck)
        .and_return(['idiot'])
    end

    let(:body_text) { 'Du bist ein Idiot' }

    it 'marks message as spam with offensive content reason' do
      expect(result.spam).to be true
      expect(result.reason).to eq('Offensive content')
    end
  end

  context 'suspicious content' do
    describe 'subject vs body rules' do
      context 'single-word subject' do
        let(:subject_text) { 'Hello' }
        let(:body_text)    { 'I need help with something' }

        it 'is not spam' do
          expect(result.spam).to be false
        end
      end

      context 'single-word body' do
        let(:subject_text) { 'Hello' }
        let(:body_text)    { 'mpTcuDhdzftZabPavQAUvoDp' }

        it 'is spam' do
          expect(result.spam).to be true
          expect(result.reason).to eq('Suspicious content')
        end
      end

      context 'no vowels in subject' do
        let(:subject_text) { 'Ths s tst' }
        let(:body_text)    { 'This is a normal body with vowels.' }

        it 'is spam' do
          expect(result.spam).to be true
          expect(result.reason).to eq('Suspicious content')
        end
      end
    end
  end
end
