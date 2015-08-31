require 'spec_helper'

describe 'profile', type: :model do
  describe '#name_or_email' do
    context 'user has no name information' do
      let(:inge) { Profile.new(email: "test@test.de") }

      it 'return the email adress' do
        expect(inge.name_or_email).to eq "test@test.de"
      end
    end

    context 'user has name information' do
      let(:inge) { Profile.new(email: "test@test.de", firstname: "Inge", lastname: "Borg") }

      it 'return the fullname' do
        expect(inge.name_or_email).to eq "Inge Borg"
      end
    end

  end
end
