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
    Given there is a category with the name: abc
    And you view the admin dashboard in <language>
    When you click on: <area>
    Then you are able to see: Administration::<area>
    And you see a link labeled as: <link>
    And you see a link labeled as: <link2>
    And you see a link labeled as: <link3>
    And you see a table with columns: <germanName>, <englishName>

# languages are implemented in localization_steps.rb
     Examples:
    | language | link       | germanName | englishName | area       | link2      | link3   |
    | English  | Add        | German     | English     | Categories | Edit       | Delete  |
    | German   | Hinzufügen | Deutsch    | Englisch    | Kategorien | Bearbeiten | Löschen |

  Scenario Outline: viewing edit certain category in admin area
    Given there is a category with the name: abc
    And you view the admin area <area> in <language>
    When you click on: <edit>
    Then you are able to see: Administration::<area>::<edit>
    And you see a button labeled as: <update_button>
    And you are able to see: <current>
    And you are able to see: <new>

    Examples:
    | language | area       | edit       | update_button | current         | new        |
    | English  | Categories | Edit       | Ok            | Current name    | New name   |
    | German   | Kategorien | Bearbeiten | Ok            | Bisheriger Name | Neuer Name |

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
    | language | area | filterTags                      | noOfSearchResults           | filter  |
    | English  | Tags | Search for tag                  | The number of all tags is   | Filter  |
    | German   | Tags | Suche nach einem bestimmtem tag | Die Anzahl aller tags ist   | Filtern |

  Scenario Outline: page has header
    Given you <are_or_are_not> signed in as <role>
    When you view the page in <language>
    Then you see the speakerinnen logo
    And you see links labeled as: <links>

# languages are implemented in localization_steps.rb
    Examples:
    | language | are_or_are_not | role  | links                                             |
    | English  | are not        | user  | Register as a speaker, Log in, DEU                |
    | English  | are            | user  | My profile, Account, Log out, DEU                 |
    | English  | are            | admin | My profile, Account, Log out, Admin, DEU          |
    | German   | are not        | user  | Als Speakerin registrieren, Anmelden, ENG         |
    | German   | are            | user  | Mein Profil, Benutzerkonto, Ausloggen, ENG        |
    | German   | are            | admin | Mein Profil, Benutzerkonto, Ausloggen, Admin, ENG |

  Scenario Outline: viewing the start page
    Given you are on the start page
    When you view the page in <language>
    Then you view the header <links> in <language>
    And you are able to see sections: <titles>
    And you see images: curie-photo, coaching-photo, speakerin-photo
    And you see links labeled as: <links>

# languages are implemented in localization_steps.rb
    Examples:
    | language | titles                                                                                                                                                                                               |  links                                |
    | English  | Organizers, find your speakers; Our Speakers; We believe in collaboration — not competition; Our Categories; Do you have something interesting to say?; Speakerinnen*; Contact                |  Log in, Register as a speaker        |
    | German   | Mehr Frauen auf die Bühnen!; Unsere Speakerinnen*; Wir glauben an Kollaboration - nicht an Wettbewerb.; Unsere Kategorien; Hast Du etwas Interessantes zu erzählen?; Speakerinnen*; Kontakt |  Anmelden, Als Speakerin registrieren |

  Scenario Outline: view contact page
    Given you are on the start page
    And you view the page in <language>
    When you click on: <contact_email>
    Then you see a button labeled as: <send>
    And you are able to see: <heading>
    And you see a form with labels: <labels>

    Examples:
    | language | contact_email | send   | heading | labels                                                    |
    | English  | Email         | Send   | Contact | Your name, Your email address, Subject, Your message      |
    | German   | E-Mail        | Senden | Kontakt | Dein Name, Deine E-Mail-Adresse, Betreff, Deine Nachricht |

#TODO test "angemeldet bleiben"-Cookie, Anmelden via Twitter
  Scenario Outline: login test
    Given there is a user registered with the email address: <email> authenticating with password: <password>
    And you are on the login page
    And you view the page in German
    When you fill in the form with: <submitted_email>, <submitted_password>
    And you click on button: Anmelden
    Then you see <result_type>: <result>

    Examples:
    | email         | submitted_email | password      | submitted_password | result                          | result_type    |
    | ltest@exp.com | ltest@exp.com   | rightpassword | rightpassword      | #empty                          | notices        |
    | ltest@exp.com | ltest@exp.com   | rightpassword | wrongpassword      | Ungültige Anmeldedaten.         | alert messages |
    | ltest@exp.com | ltest@exp.com   | rightpassword |                    | Ungültige E-Mail oder Passwort. | alert messages |
    | ltest@exp.com | false@exp.com   | rightpassword | rightpassword      | Ungültige E-Mail oder Passwort. | alert messages |
    | ltest@exp.com | ltest@exp       | rightpassword | rightpassword      | Ungültige E-Mail oder Passwort. | alert messages |
    | ltest@exp.com |                 | rightpassword | rightpassword      | Ungültige Anmeldedaten.         | alert messages |
    | ltest@exp.com |                 | rightpassword |                    | Ungültige Anmeldedaten.         | alert messages |
#TODO write jasmine tests for cases covered by javascript beforeSend function:
#| ltest@exp.com | ltest           | rightpassword | rightpassword      | Please include an '@' in the email address. |
#| ltest@exp.com | ltest@          | rightpassword | rightpassword      | Please add a part following '@'.            |
