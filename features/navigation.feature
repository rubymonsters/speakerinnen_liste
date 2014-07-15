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
And you see admin action links: <links>

# languages are implemented in localization_steps.rb
Examples:
| language | links                      |
| English  | Categories, Tags, Profiles |
| German   | Kategorien, Tags, Profile  |


Scenario Outline: viewing edit categories in admin area
Given you view the admin dashboard in <language>
When you click on: <area>
Then you are able to see: Administration::<area>
And you see a link labeled as: <link>
And you see a table with columns: <germanName>, <englishName>

# languages are implemented in localization_steps.rb
 Examples:
| language | link       | germanName | englishName | area       |
| English  | Add        | German     | English     | Categories |
| German   | Hinzufügen | Deutsch    | Englisch    | Kategorien |

Scenario Outline: view add category in admin area
Given you view the admin area <area> in <language>
When you click on: <add>
Then you are able to see: Administration::<area>::<add>
And you are able to see: <label>
And you see a button labeled as: <add>

Examples:
| language | area       | add        | label              |
| English  | Categories | Add        | Category name      |
| German   | Kategorien | Hinzufügen | Name der Kategorie |

Scenario Outline: viewing edit profiles in admin area
Given there is a user profile registered and published with the email address: user1@example.com
And there is an admin profile registered and invisible with the email address: adm@example.com
And you view the admin dashboard in <language>
When you click on: <area>
Then you are able to see: Administration::<area>
And you see a button labeled as: <link>
And you see a button labeled as: <link2>
And you see a table with columns: <person>, <created_at>, <media_links>, <visibility>, <roles>, <comment>
And you see a button labeled as: <link3>

# languages are implemented in localization_steps.rb
Examples:
| language | area     | link       | link2      | link3                | person       | created_at  | media_links | visibility   | roles  | comment   |
| English  | Profiles | public     | invisible  | Add comment          | Speakerinnen | Created at  | Media Links | Visibility   | Roles  | Comment   |
| German   | Profile  | öffentlich | unsichtbar | Kommentar hinzufügen | Speakerinnen | Erstellt am | Media Links | Sichtbarkeit | Rollen | Kommentar |

Scenario Outline: viewing edit certain profile in admin area
Given you view the admin area <area> in <language>
When you click on: <edit>
Then you are able to see: Administration::<area>::<edit>
And you see a button labeled as: <update_button>
And you see a link labeled as: <show_button>
And you see a link labeled as: <show_all_button>
And you see a form with labels: <first_name>, <last_name>, <city>, <picture>, <bio>, <topic>, <topics_as_tags>

# languages are implemented in localization_steps.rb
Examples:
| language | area     | edit       | update_button            | show_button  | show_all_button     | first_name | last_name | city  | picture | bio       | topic           | topics_as_tags        |
| English  | Profiles | Edit       | Update your profile      | Show profile | List all profiles   | First name | Last name | City  | Picture | Your bio  | Your main topic | Your topics as tags   |
| German   | Profile  | Bearbeiten | Aktualisiere dein Profil | Zeige Profil | Liste aller Profile | Vorname    | Nachname  | Stadt | Bild    | Deine Bio | Dein Hauptthema | Deine Themen als Tags |

Scenario Outline: viewing edit tags in admin area
Given you view the admin dashboard in <language>
When you click on: <area>
Then you are able to see: Administration::<area>
And you are able to see: <filterTags>
And you are able to see: <noOfSearchResults>
And you see a button labeled as: <filter>

# languages are implemented in localization_steps.rb
Examples:
| language | area | filterTags                      | noOfSearchResults       | filter  |
| English  | Tags | Search for tag                  | The number of tags is   | Filter  |
| German   | Tags | Suche nach einem bestimmtem Tag | Die Anzahl der Tags ist | Filtern |
