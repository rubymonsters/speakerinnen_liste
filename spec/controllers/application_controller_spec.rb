RSpec.configure do |c|
  c.infer_base_class_for_anonymous_controllers = false
end

RSpec.describe ApplicationController, :type => :controller do
  describe 'helper methods' do
    it 'build missing translations' do
      class FakeModel < ActiveRecord::Base
        translates :fake_attr1, :fake_attr2
      end
      controller.send :build_missing_translations, FakeModel.new
    end
  end
end
