Feature: Fake a tweet

  Scenario: Visit home page and submit a twitter handle
    Given I go to the home page
    And "someTweeter" has tweeted "So this is christmas"
    And "someTweeter" has tweeted "And what have we done"
    When I fill in "screen_name" with "someTweeter"
    And I press "Fake it"
    Then I should see /So this is christmas|And what have we done/

  Scenario: Submit a non-existent handle
    Given I go to the home page
    When I fill in "screen_name" with the non-existent screen-name "someFakeName"
    And I press "Fake it"
    Then I should see "We couldn't find that username."

  Scenario: Valid user has no tweets
    Given I go to the home page
    And "nonTweeter" has no tweets
    When I fill in "screen_name" with "nonTweeter"
    And I press "Fake it"
    Then I should see "nonTweeter doesn't have enough tweets."