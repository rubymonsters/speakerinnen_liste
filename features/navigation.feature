Feature: Navigation

Scenario Outline: signed in as <role>
Given you are signed in as <role>
When you view the page in <language>
Then you see <target>

# languages are implemented in localization_steps.rb
Examples:
| language | role  | target         |
| English  | admin | the admin link |
| German   | admin | the admin link |
| English  | user  | no admin link  |
| German   | user  | no admin link  |


Scenario Outline: viewing the admin dashboard
Given you are signed in as admin
And you view the page in <language>
When you click on the admin link
Then you are able to see the admin dashboard
And you are able to access the admin actions in <language>

# languages are implemented in localization_steps.rb
Examples:
| language |
| English  |
| German   |
