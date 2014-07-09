Feature: Navigation

Scenario: signed in as admin
Given you are signed in as admin
When you go to the start page
Then you see the admin link
And you are able to access the admin actions

Scenario: signed in as normal user
Given you are signed in as normal user
When you go to the start page
Then you can't see the admin link