When /^you go to the start page$/ do
  visit root_path
end

Then /^you see the admin link$/ do
  expect(page).to have_link('Admin',admin_root_path)
end

And /^you are able to access the admin actions$/ do
  click_on 'Admin'
  expect(page).to have_content('Admin::Dashboard')
  expect(page).to have_link('Bearbeite Kategorien', categorization_admin_tags_path)
  expect(page).to have_link('Bearbeite Tags', admin_categories_path)
  expect(page).to have_link('Bearbeite Profile', admin_profiles_path)
end

Then /^you can't see the admin link$/ do 
  expect(page).to have_no_link('Admin',admin_root_path)
end