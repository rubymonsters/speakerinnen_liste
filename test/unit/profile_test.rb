require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  fixtures :profiles

  test 'firstname is there' do
    assert_equal profiles(:one).firstname, 'Ada', 'Firstname is there'
  end

  test 'admin? is true when an admin user' do
    profile       = Profile.new
    profile.admin = true
    profile.save
    assert profile.admin?, 'returns true for an admin'
  end

  test 'admin? is false for non-admin user' do
    profile       = Profile.new
    profile.admin = false
    profile.save
    assert(!profile.admin?, 'returns false for non-admin')
  end

  test 'admin? is false by default' do
    assert(!Profile.new.admin?, 'default setting for admin is false')
  end

  test 'does not validate profile without email' do
    testprofile = Profile.new(
      firstname: 'Testfirstname',
      lastname:  'Testlastname',
      bio:       'Testbio'
    )
    testprofile.valid?

    assert !testprofile.valid?, 'Does not validate Profile without email'
  end

  test 'does not validate profile with already taken email' do
    testprofile = Profile.new(email: 'ada@mail.de')
    testprofile.valid?
    assert !testprofile.valid?, 'Does not validate Profile with already taken email'
  end

  test 'fullname is firstname plus lastname' do
    assert_equal profiles(:one).fullname, profiles(:one).firstname + ' ' + profiles(:one).lastname, 'Fullname is there'
    assert_equal profiles(:one).fullname, 'Ada Lovelace', 'Fullname is there'
  end

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

  test 'should convert profile attributes to json' do
    horst = profiles(:one)
    horst.id = 1
    horst.created_at = Time.zone.parse('2014-12-06 15:04:13')
    horst.updated_at = Time.zone.parse('2014-12-06 15:04:20')
    horst.medialinks = [medialinks(:one)]

    I18n.locale = :en
    horst.bio        = 'english bio'
    horst.main_topic = 'english main topic'

    I18n.locale = :de
    horst.bio        = 'deutsche bio'
    horst.main_topic = 'deutsches Hauptthema'

    parsed_json      = JSON.parse(horst.to_json)

    assert_equal(
      parsed_json,
      'id'         => 1,
      'firstname'  => 'Ada',
      'lastname'   => 'Lovelace',
      #'languages'  => 'Deutsch',
      'city'       => 'New York',
      'country'    => nil,
      'twitter'    => 'alove',
      'created_at' => '2014-12-06T15:04:13.000Z',
      'updated_at' => '2014-12-06T15:04:20.000Z',
      'website'    => nil,
      'medialinks' => [{ 'url' => 'MyString', 'title' => 'MyString', 'description' => nil, 'position' => nil }],
      'topics'     => [],
      'picture'    => { 'original' => nil, 'profile_small' => nil, 'profile_smallest' => nil },
      'bio'        => { 'en' => 'english bio', 'de' => 'deutsche bio' },
      'main_topic' => { 'en' => 'english main topic', 'de' => 'deutsches Hauptthema' }
    )
  end
end
