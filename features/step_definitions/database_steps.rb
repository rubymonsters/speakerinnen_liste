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

Given /^there is (a|an) (user|admin) profile registered and (published|invisible) with the email address: (.+)$/ do |article, role, visibility, email|
  user = FactoryGirl.create(:user, email: email)
  if (role == 'admin')
    user.admin = true
  end
  if (visibility == 'published')
    user.published = true
  else
    user.published = false
  end
  user.save!
end

Given /^there is a category with the name: (.+)$/ do |name|
  category = FactoryGirl.create(:category, name: name)
  category.save!
end

###########
# 2) When #
###########

###########
# 3) Then #
###########
