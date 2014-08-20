Feature: Profiles

  @javascript
  @wip
  Scenario Outline: tags are autocompleted when you edit profiles
    Given there are tags: rspec, cucumber, pixelheart, plants
    And you are signed in as admin
    When you click on: Admin
    And you click on: Profile
    And you click on: Bearbeiten in list line Factory Girl
    And you start typing <input> in autocomplete field
    Then you see a box with autocompletion suggestions: <suggestions>

    Examples:
    | input | suggestions |
    | r     | rspec       |
    | R     | rspec       |
