require 'test_helper' 

class SignUpTest < ActionController::IntegrationTest
  #def setup
    #horst = profiles(:one)
    #horst.confirmed_at = Time.now
    #horst.save
  #end

  test "sign up with email sends out confirmation link" do
    visit '/'
    assert page.has_content?('Sign up')
    click_link('Sign up as a speaker')
    fill_in('profile[email]', :with => 'bettina@mail.de')
    fill_in('profile[password]', :with => 'Testpassword')
    fill_in('profile[password_confirmation]', :with => 'Testpassword')
    click_button "Sign up"
    # opens the site where you are in the test right now
    save_and_open_page
    assert page.has_content?('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
  end
  
  # test "sign up is completed by using the confirmation link" do
  #     visit '/'
  #     assert page.has_content?('Sign up')
  #     click_link('Sign up as a speaker')
  #     fill_in('profile[email]', :with => 'horst@mail.de')
  #     fill_in('profile[password]', :with => 'Testpassword')
  #     fill_in('profile[password_confirmation]', :with => 'Testpassword')
  #     fill_in('profile[confirmation_token]')
  #     click_button "Sign up"
  #     # opens the site where you are in the test right now
  #     save_and_open_page
  #     #problem: can't sign in with an email that has already been taken. So test fails
  #     #if it runs for the second time
  #     assert page.has_content?('Your account was successfully confirmed. You are now signed in.')
  #   end

   test "sign up with email doesn't work when email is already been taken" do
      visit '/'
      assert page.has_content?('Sign up')
      click_link('Sign up as a speaker')
      fill_in('profile[email]', :with => 'horst@mail.de')
      fill_in('profile[password]', :with => 'Testpassword')
      fill_in('profile[password_confirmation]', :with => 'Testpassword')
      click_button "Sign up"
      # opens the site where you are in the test right now
      save_and_open_page
      #problem: can't sign in with an email that has already been taken. So test fails
      #if it runs for the second time
      assert page.has_content?('Email has already been taken')
    end

    #test "sign up with twitter works and redirects to the profile edit page" do
    #end
end