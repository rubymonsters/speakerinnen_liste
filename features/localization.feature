Feature: Localization

  Scenario Outline: start page localization
    Given you are on the start page
    When you view the page in <language>
    Then you see a link labeled as: <login_link>
    And you see a button labeled as: <search_button>

    Examples:
    | language | login_link | search_button |
    | German   | Anmelden   | Suche         |
    | English  | Log in     | Search        |
