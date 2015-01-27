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
Given /^you are on the (.+)$/ do |page|
  path = case page
    when 'start page' then root_path
    when 'login page' then new_profile_session_path
  end
  visit path
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
When /^you click on(.*): (.+)$/ do |type, label|
  if label.include?('in list line')
    parts = label.split('in list line')
    xpath = '//tr[*//*[contains(text(), ":match1")]]//*[contains(text(), ":match2")]'
    xpath.gsub!(':match1',parts[1].strip).gsub!(':match2',parts[0].strip)
    element = page.all(:xpath,xpath).first
    element.click
  else
    case type.strip
      when 'button' then click_button(label, match: :first)
      when 'link' then click_link(label, match: :first)
      else click_on(label, match: :first)
    end
  end
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

def comma_separated_string_to_array(string, separator=',', empty_string_marker='#empty')
  strings_with_leading_spaces = string.split(separator)
  array = []
  strings_with_leading_spaces.each do |item|
    if item == empty_string_marker
      item = ''
    end
    array << item.strip
  end

  return array
end

Then /^you see (a table with columns|a form with labels|images|alert messages|notices): ((.+)(,.+)*)$/ do |type, match, unused, unused2|
  items = comma_separated_string_to_array(match)
  xpath = case type
    when 'a table with columns' then '//table/thead/tr/th[contains(text(), ":match")] | //table/thead/tr/th/a[contains(text(), ":match")]'
    when 'a form with labels' then '//form//label[contains(text(), ":match")]'
    when 'images' then '//*[@id=":match"]'
    when 'alert messages' then '//p[@class="alert" and contains(text(), ":match")]'
    when 'notices' then '//p[@class="notice" and contains(text(), ":match")]'
  end

  items.each do |item|
    expect(page).to have_xpath(xpath.gsub(':match', item))
  end
end

Then /^you fill in the form with: ((.+)(,.+)*)$/ do |match, unused, unused2|
  input_fields = page.all(:xpath, '//form//input[@type != "submit" and @type != "checkbox" and @type != "hidden"]')
  items = comma_separated_string_to_array(match)

  input_fields.each_with_index do |input_field,index|
    input_field.set(items[index])
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

When(/^you visit a unpublished profile$/) do
  visit ('/profile/1')
end





