
Given /^you are signed in as admin$/ do  
  @admin = FactoryGirl.create(:admin)
  sign_in @admin
end

Given /^you are signed in as normal user$/ do
    @user = FactoryGirl.create(:user)
  sign_in @user
end
