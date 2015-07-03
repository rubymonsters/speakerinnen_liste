###############
# conventions #
###############
# All steps are ordered by their categories:
# 1) Given
# 2) When
# 3) Then
#
# Each step file groups certain steps together.
# This step file contains all steps to:
# change the language anywhere on the website.

############
# 1) Given #
############

Given /^you view the page in (English|German)$/ do |language|
  lang_short_map = {
    'English' => 'EN',
    'German' => 'DE',
  }
  if page.has_link?(lang_short_map[language])
    click_on(lang_short_map[language], match: :first)
  end
end

###########
# 2) When #
###########

###########
# 3) Then #
###########
