RSpec.describe ContactForm::SubmitInteractor do
  let(:valid_params) do
    { name: 'Test', email: 'horst@example.org', subject: 'Hi', body: 'That is a Message' }
  end
  let!(:ada) { create(:profile, email: 'ada@example.org') }

  context 'sents email successfully' do
    it 'to us when no speakerin profile is given' do
      result = described_class.call(params: valid_params, profile: nil)
      expect(result).to be_success
      expect(result.skip_delivery).to be nil
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'to the speakerin and a copy to the sender when a speakerin profile is given' do
      result = described_class.call(params: valid_params, profile: ada)
      expect(result).to be_success
      expect(result.skip_delivery).to be nil
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end
  end

  describe 'fishy email address' do
    it 'no email sent but pretends success and adds to BlockedEmail' do
      stub_const('ENV', ENV.to_hash.merge('FISHY_EMAILS' => 'spam@example.com'))

      expect do
        result = described_class.call(params: valid_params.merge(email: 'spam@example.com'), profile: nil)
        expect(result).to be_success
        expect(result.skip_delivery).to be true
      end.not_to(change { ActionMailer::Base.deliveries.count })
      expect(BlockedEmail.count).to eq(1)
      expect(BlockedEmail.last.reason).to eq('Spam email')
    end
  end

  describe 'offensive terms' do
    it 'sents when just one word of the offensive term is used ' do
      offensive_term = 'du Nazi'
      OffensiveTerm.create!(word: offensive_term)

      expect do
        result = described_class.call(params: valid_params.merge(body: 'This is a test message with Nazi.'), profile: nil)
        expect(result).to be_success
        expect(result.skip_delivery).to be nil
      end.to(change { ActionMailer::Base.deliveries.count })

      expect(BlockedEmail.count).to eq(0)
    end

    context 'pretends success without sending email with offensive content' do
      context 'contact us form' do
        it 'containing offensive terms' do
          offensive_term = 'du Nazi'
          OffensiveTerm.create!(word: offensive_term)

          expect do
            result = described_class.call(params: valid_params.merge(body: "This is a test message with #{offensive_term}."), profile: nil)
            expect(result).to be_success
            expect(result.skip_delivery).to be true
          end.not_to(change { ActionMailer::Base.deliveries.count })

          expect(BlockedEmail.count).to eq(1)
        end

        it 'offensive term in the body' do
          offensive_term = 'Esel'
          OffensiveTerm.create!(word: offensive_term)
          expect do
            result = described_class.call(params: valid_params.merge(body: 'This is a test message with Esel.'), profile: nil)
            expect(result).to be_success
            expect(result.skip_delivery).to be true
          end.not_to(change { ActionMailer::Base.deliveries.count })
          expect(BlockedEmail.count).to eq(1)
          expect(BlockedEmail.last.body).to include('Esel')
          expect(BlockedEmail.last.contacted_profile_email).to eq('team@speakerinnen.org')
          expect(BlockedEmail.last.reason).to eq('Offensive content')
        end

        it 'offensive term in the subject' do
          offensive_term = 'Esel'
          OffensiveTerm.create!(word: offensive_term)
          expect do
            result = described_class.call(params: valid_params.merge(subject: "This is a test message with #{offensive_term}."), profile: nil)
            expect(result).to be_success
            expect(result.skip_delivery).to be true
          end.not_to(change { ActionMailer::Base.deliveries.count })
          expect(BlockedEmail.count).to eq(1)
          expect(BlockedEmail.last.reason).to eq('Offensive content')
        end
      end
    end
  end

  context 'contact speakerin form' do
    it 'creates blocked email with correct contacted_profile_email when speakerin profile is given' do
      offensive_term = 'Dummkopf'
      OffensiveTerm.create!(word: offensive_term)

      expect do
        result = described_class.call(params: valid_params.merge(subject: offensive_term.to_s), profile: ada)
        expect(result).to be_success
        expect(result.skip_delivery).to be true
      end.not_to(change { ActionMailer::Base.deliveries.count })

      expect(BlockedEmail.count).to eq(1)
      expect(BlockedEmail.last.contacted_profile_email).to eq(ada.email)
      expect(BlockedEmail.last.reason).to eq('Offensive content')
    end
  end

  context 'with suspicious content' do
    it 'pretends success for gibberish messages without sending mail' do
      expect do
        result = described_class.call(params: valid_params.merge(subject: 'mpTcuDhdzftZabPavQAUvoDp', body: 'mpTcuDhdzftZabPavQAUvoDp'), profile: ada)
        expect(result).to be_success
        expect(result.skip_delivery).to be true
      end.not_to(change { ActionMailer::Base.deliveries.count })
      expect(BlockedEmail.count).to eq(1)
      expect(BlockedEmail.last.reason).to eq('Suspicious content')
    end
  end
end
