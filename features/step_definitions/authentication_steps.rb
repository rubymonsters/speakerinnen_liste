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
# simulate a user with a certain role and certain
# permission attributes.

############
# 1) Given #
############

Given /^you (are|are not) signed in as (user|admin)$/ do |signIn,role|
  if signIn == 'are'
    @user = (role == 'admin') ? FactoryGirl.create(:admin) : FactoryGirl.create(:user)
    sign_in @user
  else
    visit root_path
  end
end

###########
# 2) When #
###########

###########
# 3) Then #
###########
