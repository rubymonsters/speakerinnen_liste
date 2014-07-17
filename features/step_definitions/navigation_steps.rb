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


Then /^you view the header (.*) in (German|English)$/ do |links, language|
  steps %Q{
    When you view the page in #{language}
    And you see links labeled as: #{links}
  }
end

Then /^you see (a|no) link labeled as: (.+)$/ do |visibility,label|
  if (visibility == 'a')
    expect(page).to have_link(label)
  else
    expect(page).to have_no_link(label)
  end
end

Then /^you see the speakerinnen logo$/ do
  expect(page).to have_xpath('//*[@id="logo"]')
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

Then /^you see admin action links: ((.+)(,.+)*)$/ do |match,unused,unused2|
  # LINKS_ARRAY must be inside a step definition because otherwise the _paths 
  # do not get resolved by the rails routing mechanism
  LINKS_ARRAY = [categorization_admin_tags_path, admin_categories_path, admin_profiles_path]
  links = comma_separated_string_to_array(match)
  links.each_with_index do |link, index|
    expect(page).to have_link(link, LINKS_ARRAY[index])
  end
end

def comma_separated_string_to_array(string, separator=',')
  strings_with_leading_spaces = string.split(separator)
  array = []
  strings_with_leading_spaces.each do |item|
    array << item.strip
  end

  return array
end

Then /^you see (a table with columns|a form with labels|images): ((.+)(,.+)*)$/ do |type, match, unused, unused2|
  items = comma_separated_string_to_array(match)
  xpath = case type
    when 'a table with columns' then '//table/thead/tr/th[contains(text(), ":match")] | //table/thead/tr/th/a[contains(text(), ":match")]'
    when 'a form with labels' then '//form//label[contains(text(), ":match")]'
    when 'images' then '//*[@id=":match"]'
  end

  items.each do |item|
    expect(page).to have_xpath(xpath.gsub(':match', item))
  end
end

Then /^you are able to see sections: ((.+)(,.+)*)$/ do |match, unused, unused2|
  labels = comma_separated_string_to_array(match, ';')
  titles =  page.all(:xpath, '//div/h1')

  labels.each_with_index do |label, index|
    assert_equal(label, titles[index].text)
  end
end

Then /^you see links labeled as: ((.+)(,.+)*)$/ do |match, unused, unused2|
  links = comma_separated_string_to_array(match)
  links.each do |link|
    expect(page).to have_link(link)
  end
end
