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

Given /^you view the admin area (.*) in (German|English)$/ do |area, language|
  steps %Q{
    Given you view the admin dashboard in #{language}
    And you click on: #{area}
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

#LANG_LINKS_MAP = {
#  'English' => ['Edit Categories','Edit Tags','Edit Profiles'],
  #'German' => ['Bearbeite Kategorien', 'Bearbeite Tags', 'Bearbeite Profile']
#}

Then /^you see admin action links: ((.+)(,.+)*)$/ do |match,unused,unused2|
  LINKS_ARRAY = [categorization_admin_tags_path, admin_categories_path, admin_profiles_path]
  links = comma_separated_string_to_array(match)
  links.each_with_index do |link, index|
    expect(page).to have_link(link, LINKS_ARRAY[index])
  end
end

def comma_separated_string_to_array(string)
  strings_with_leading_spaces = string.split(',')
  array = []
  strings_with_leading_spaces.each do |item|
    array << item.strip
  end

  return array
end

Then /^you see a table with columns: ((.+)(,.+)*)$/ do |match, unused, unused2|
  columns = comma_separated_string_to_array(match)
  #binding.pry
  columns.each do |column|
    expect(page).to have_xpath('//table/thead/tr/th[contains(text(), "'+column+'")] | //table/thead/tr/th/a[contains(text(), "'+column+'")]')
  end
end

Then /^you see a form with labels: ((.+)(,.+)*)$/ do |match, unused, unused2|
  labels = comma_separated_string_to_array(match)

  labels.each do |label|
    expect(page).to have_xpath('//form//label[contains(text(), "'+label+'")]')
  end
end
