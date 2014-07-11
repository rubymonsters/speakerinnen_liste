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
# navigate through the page and to validate navigation elements.

############
# 1) Given #
############

###########
# 2) When #
###########
When /^you click on the admin link$/ do
  click_on 'Admin'
end

###########
# 3) Then #
###########
Then /^you see (the|no) admin link$/ do |visibility|
  if visibility == 'the'
    expect(page).to have_link('Admin',admin_root_path)
  else
    expect(page).to have_no_link('Admin',admin_root_path)
  end
end

Then /^you are able to see the admin dashboard$/ do
  expect(page).to have_content('Admin::Dashboard')
end

Then /^you are able to access the admin actions in (English|German)$/ do |language|
  links_array = [categorization_admin_tags_path, admin_categories_path, admin_profiles_path]
  lang_links_map = {
    'English' => ['Edit Categories','Edit Tags','Edit Profiles'],
    'German' => ['Bearbeite Kategorien', 'Bearbeite Tags', 'Bearbeite Profile']
  }
  lang_links_map[language].each_with_index do |link, index|
    expect(page).to have_link(link, links_array[index])
  end
end
