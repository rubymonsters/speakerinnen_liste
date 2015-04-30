module SignInHelper
	# default locale of the site is 'de', so we set the same default here
	def sign_in(profile,language='de')
			visit new_profile_session_path
			lang_map = { 'de' => 'DE', 'en' => 'EN' }
			if page.has_link?(lang_map[language])
				click_on lang_map[language]
			end
			fill_in "profile[email]", with: profile.email
			fill_in "profile[password]", with: profile.password
			click_button I18n.t("devise.sessions.new.login")
	end
end
