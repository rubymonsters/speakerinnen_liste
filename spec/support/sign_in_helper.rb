module SignInHelper
	def sign_in(user,language)
			visit '/'+language
			visit new_profile_session_path
			fill_in "profile[email]", with: user.email
			fill_in "profile[password]", with: user.password
			click_button I18n.t("devise.sessions.new.login")
      #TODO add localization support (auto-dectect current locale)
	end
end
