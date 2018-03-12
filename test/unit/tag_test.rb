require 'test_helper'

class TagTest < ActiveSupport::TestCase
  fixtures :profiles

  test 'tag forced lowercased' do
    assert_equal profiles(:one).topics.length, 0
    profiles(:one).topic_list.add('Juni')
    profiles(:one).save!
    assert_equal profiles(:one).topic_list.first, 'juni', 'Tags are lowercase after saving them'
  end
end
