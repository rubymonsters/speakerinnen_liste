require 'test_helper'
require 'capybara/poltergeist'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

Capybara.javascript_driver = :poltergeist

class JavascriptTest < ActionDispatch::IntegrationTest
  self.use_transactional_fixtures = false
  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    DatabaseCleaner.start
    @inge              = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list   = "Fruehling"
    @inge.published    = true
    @inge.save

    @horst              = profiles(:one)
    @horst.confirmed_at = Time.now
    @horst.published    = true
    @horst.save
  end

  teardown do
    DatabaseCleaner.clean
  end

  test 'using tag autocompletion' do
    skip "This uses tag-it now, haven't figured out yet how to test that."

    visit '/profiles'
    click_link('Anmelden')
    fill_in('profile[email]', :with => 'horst@mail.de')
    fill_in('profile[password]', :with => 'Testpassword')
    click_button "Anmelden"

    visit profile_path(@horst, :locale => "en")
    click_link('Edit')
    fill_in('Fr').click
    assert_equal find_field('profile[topic_list]').value, 'Fruehling'
  end
end
