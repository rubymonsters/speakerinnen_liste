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
# <TODO> Fill in description

############
# 1) Given #
############

###########
# 2) When #
###########

When /^you start typing (.+) in autocomplete field$/ do |input|
  #scenarios which use this step definition have to be tagged with @javascript
  field = page.all(:xpath, '//ul[contains(@class,"tagit")]//li[contains(@class,"tagit-new")]/input[contains(@class,"ui-autocomplete-input")]').first
  field.set(input)
end

###########
# 3) Then #
###########

Then /^you see a box with autocompletion suggestions: ((.+)(,.+)*)$/ do |match,unused,unused2|
  items = comma_separated_string_to_array(match)
  xpath = '//ul[contains(@class,"tagit-autocomplete")]//li[contains(@class,"ui-menu-item")]/a'
  # expect(page) call is necessary to make capybara wait for the ajax results
  expect(page).to have_xpath(xpath)
  suggestions_list = page.all(:xpath, xpath)
  assert_equal(items.length, suggestions_list.length)

  items.each_with_index do |item, index|
    assert_equal(item, suggestions_list[index].text)
  end
end
