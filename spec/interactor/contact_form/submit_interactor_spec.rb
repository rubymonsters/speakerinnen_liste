RSpec.describe ContactForm::SubmitInteractor do
  let(:valid_params) do
    { name: 'Test', email: 'horst@example.org', subject: 'Hi', body: 'Message' }
  end

  it 'succeeds with valid data' do
    result = described_class.call(params: valid_params, profile: nil)
    expect(result).to be_success
  end

  it 'pretends success for spammy email without sending mail' do
    stub_const('ENV', ENV.to_hash.merge('FISHY_EMAILS' => 'spam@example.com'))

    expect {
      result = described_class.call(params: valid_params.merge(email: 'spam@example.com'), profile: nil)
      expect(result).to be_success
      expect(result.skip_delivery).to be true
    }.not_to change { ActionMailer::Base.deliveries.count }
  end

  it 'pretends success for messages containing offensive terms without sending mail' do
    offensive_term = 'du Nazi'
    OffensiveTerm.create!(word: offensive_term)

    expect {
      result = described_class.call(params: valid_params.merge(body: "This is a test message with #{offensive_term}."), profile: nil)
      expect(result).to be_success
      expect(result.skip_delivery).to be true
    }.not_to change { ActionMailer::Base.deliveries.count }

    expect(BlockedEmail.count).to eq(1)
  end

  it 'when just one word of the offensive term is used the mail gets send' do
    offensive_term = 'du Nazi'
    OffensiveTerm.create!(word: offensive_term)

    expect {
      result = described_class.call(params: valid_params.merge(body: "This is a test message with Nazi."), profile: nil)
      expect(result).to be_success
      expect(result.skip_delivery).to be nil
    }.to change { ActionMailer::Base.deliveries.count }

    expect(BlockedEmail.count).to eq(0)

  end

  it 'checks the body' do
    offensive_term = 'Esel'
    OffensiveTerm.create!(word: offensive_term)
    expect {
      result = described_class.call(params: valid_params.merge(body: "This is a test message with Esel."), profile: nil)
      expect(result).to be_success
      expect(result.skip_delivery).to be true
    }.not_to change { ActionMailer::Base.deliveries.count }
    expect(BlockedEmail.count).to eq(1)
  end

  it 'checks the subject' do
    offensive_term = 'Esel'
    OffensiveTerm.create!(word: offensive_term)
    expect {
      result = described_class.call(params: valid_params.merge(subject: "This is a test message with Esel."), profile: nil)
      expect(result).to be_success
      expect(result.skip_delivery).to be true
    }.not_to change { ActionMailer::Base.deliveries.count }
    expect(BlockedEmail.count).to eq(1)
  end
end
