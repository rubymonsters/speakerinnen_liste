Feature: Navigation

Scenario Outline: signed in as <role>
Given you are signed in as <role>
When you view the page in <language>
Then you see <a_or_no> link labeled as: Admin

# languages are implemented in localization_steps.rb
Examples:
| language | role  | a_or_no |
| English  | admin | a       |
| German   | admin | a       |
| English  | user  | no      |
| German   | user  | no      |


Scenario Outline: viewing the admin dashboard
Given you are signed in as admin
And you view the page in <language>
When you click on: Admin
Then you are able to see: Administration
And you are able to access the admin actions in <language>

# languages are implemented in localization_steps.rb
Examples:
| language |
| English  |
| German   |



Scenario Outline: viewing edit categories in admin area
Given you view the admin dashboard in <language>
When you click on: <edit>
Then you are able to see: Administration::<area>
And you see a link labeled as: <link>
And you see a table with columns: <germanName>, <englishName>

# languages are implemented in localization_steps.rb
 Examples:
| language | link       | germanName | englishName | edit                 | area       |
| English  | Add        | German     | English     | Edit Categories      | Categories |
| German   | Hinzufügen | Deutsch    | Englisch    | Bearbeite Kategorien | Kategorien |