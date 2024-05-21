# frozen_string_literal: true

describe Message do
  it 'throws a validation error if the email address has a wrong syntax' do
    message = described_class.new(email: 'max.muster@musterstadt-online..de')
    message.valid?
    expect(message.errors.messages).to have_key(:email)
  end
end
