require 'test_helper'

class ProfilesTest < ActionController::IntegrationTest
  def setup
    @horst              = profiles(:one)
    @horst.confirmed_at = Time.now
    @horst.published    = true
    @horst.save

    @inge              = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.published    = true
    @inge.save

    @anon              = profiles(:three)
    @anon.confirmed_at = Time.now
    @anon.save
  end

  test "show only published Profiles on index page" do
    visit '/profiles'

    assert page.has_content?('Horst')
    assert page.has_content?('Inge')
    assert page.has_no_content?('Anon')
  end
end
