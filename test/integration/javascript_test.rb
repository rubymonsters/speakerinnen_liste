# frozen_string_literal: true

require 'test_helper'
require 'capybara/poltergeist'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

Capybara.javascript_driver = :poltergeist

class JavascriptTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = false
  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
    DatabaseCleaner.start
    @inge              = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list   = 'Algorithm'
    @inge.published    = true
    @inge.save

    @ada              = profiles(:one)
    @ada.confirmed_at = Time.now
    @ada.published    = true
    @ada.save
  end

  teardown do
    DatabaseCleaner.clean
  end

  test 'using tag autocompletion' do
    skip "This uses tag-it now, haven't figured out yet how to test that."

    visit '/profiles'
    click_link('Einloggen')
    fill_in('profile[email]', with: 'ada@mail.de')
    fill_in('profile[password]', with: 'Testpassword')
    click_button 'Anmelden'

    visit profile_path(@ada, locale: 'en')
    click_link('Edit')
    fill_in('Al').click
    assert_equal find_field('profile[topic_list]').value, 'Algorithm'
  end
end
