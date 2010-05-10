Feature: Fake a tweet

Scenario: Visit home page and submit a twitter handle
  Given I go to the home page
  When I fill in "screen_name" with "fakemytweet"
  And I press "Fake it"
  Then I should see a tweet