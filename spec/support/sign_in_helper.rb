module SignInHelper
	# default locale of the site is 'de', so we set the same default here
	def sign_in(user,language='de')
			visit '/'+language
			visit new_profile_session_path
			fill_in "profile[email]", with: user.email
			fill_in "profile[password]", with: user.password
			click_button I18n.t("devise.sessions.new.login")
	end
end
