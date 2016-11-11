require 'rails_helper'
# require 'spec_helper'

RSpec.describe ProfileSerializer, :type => :serializer do

  describe "attributes" do
    it "should include firstname as an attribute" do
      profile = FactoryGirl.build(:profile)
      p profile
      serialized = serialize(profile)
      # p serialized
      # expect(serialized["firstname"].keys).to eq ["Ada"]
      # expect(parsed["data"]["attributes"]["size"]).to eq coffee.size
    end
  end
end
