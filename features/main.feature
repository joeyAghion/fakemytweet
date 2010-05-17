Feature: Fake a tweet

  Scenario: Visit home page and submit a twitter handle
    Given "someTweeter" has tweeted the following:
    | text                  |
    | So this is christmas  |
    | And what have we done |
    When I go to the home page
    And I fill in "screen_name" with "someTweeter"
    And I press "Fake it"
    Then I should see one of:
    | text                  |
    | So this is christmas  |
    | And what have we done |

  Scenario: Submit a non-existent handle
    Given I go to the home page
    When I fill in "screen_name" with the non-existent screen-name "someFakeName"
    And I press "Fake it"
    Then I should see "We couldn't find that username."

  Scenario: Valid user has no tweets
    Given "nonTweeter" has no tweets
    When I go to the home page
    And I fill in "screen_name" with "nonTweeter"
    And I press "Fake it"
    Then I should see "nonTweeter doesn't have enough tweets."
  
  Scenario: Valid user has few tweets
    Given "fewTweeter" has tweeted the following:
    | text                  |
    | So this is christmas  |
    | And what have we done |
    When I go to the home page
    When I fill in "screen_name" with "fewTweeter"
    And I press "Fake it"
    Then I should see "fewTweeter has very few tweets. Try the suggestions for a little variety."

  Scenario: Suggest users in sidebar
    Given "BarackObama" has tweeted "Vote for change"
    When I go to the home page
    Then I should see "Barack Obama"
    When I follow the "Barack Obama" suggested user link
    Then I should see "Vote for change"
