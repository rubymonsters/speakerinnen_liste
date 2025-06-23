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
end
