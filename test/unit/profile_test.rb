require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  fixtures :profiles

  test 'that profile is properly built from twitter omniauth' do
    h       = Hashie::Mash.new(provider: 'twitter', uid: 'uid', info: { nickname: 'nickname', name: 'Maren' })
    profile = Profile.from_omniauth(h)
    assert_equal profile.uid, 'uid'
    assert_equal profile.twitter, 'nickname'
  end

  test 'twitter @ symbol correcty removed' do
    testprofile      = Profile.new(twitter: '@tweeter', email: 'me@me.com')
    expected_twitter = 'tweeter'
    assert expected_twitter, testprofile.twitter
  end
end
