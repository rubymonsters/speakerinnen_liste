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
Given /^you are on the start page$/ do
  visit root_path
end

Given /^you view the admin dashboard in (German|English)$/ do |language|
  steps %Q{
    Given you are signed in as admin
    And you view the page in #{language}
    And you click on: Admin
  }
end


###########
# 2) When #
###########
When /^you click on: (.+)$/ do |label|
  click_on label
end

###########
# 3) Then #
###########
Then /^you see (a|no) link labeled as: (.+)$/ do |visibility,label|
  if (visibility == 'a')
    expect(page).to have_link(label)
  else
    expect(page).to have_no_link(label)
  end
end

Then /^you see (a|no) button labeled as: (.+)$/ do |visibility,label|
  if (visibility == 'a')
    expect(page).to have_button(label)
  else
    expect(page).to have_no_button(label)
  end
end

Then /^you are able to see: (.+)$/ do |label|
  expect(page).to have_content(label)
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

Then /^you see a table with columns: (.+)(,.+)*$/ do |match|
  columns_with_leading_spaces = match[0].split
  columns = []
  columns_with_leading_spaces.each do |column|
    columns << column.strip
  end
  
  columns.each do |column|
    page.all('th', :text => column)
  end
end




