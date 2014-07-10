module SignInHelper
    def sign_in(user)
            visit new_profile_session_path
            fill_in "profile[email]", with: user.email
            fill_in "profile[password]", with: user.password
            click_button "Anmelden"
      #TODO add localization support (auto-dectect current locale)
    end
end

World(SignInHelper)