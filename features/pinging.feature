Feature: Pinging

  Background:
    Given the date/time is "2011-01-01 00:00:00 UTC"
    And requests to "http://example.com" are returning the status code "200"

  Scenario: Adding a URL
    When I go to the page where I can add a URL
    And I fill in the following:
      | Title   | Example Home       |
      | URL     | http://example.com |
      | Seconds | 600                |
    And I select "POST" from "HTTP method"
    And I press "Add URL"
    Then I should see "Sending a POST request to http://example.com every 600 seconds."



  Scenario: Viewing the pings
    When I create the URL:
      | URL     | http://example.com |
      | Seconds | 600                |
    And I should see "Next ping in 10 minutes."
    And I should see "No pings yet"

    And I refresh the page after 7 minutes
    Then I should see "Next ping in 3 minutes."
    And I should see "No pings yet"

    And I refresh the page after 5 minutes
    Then I should see "Next ping in 8 minutes."
    And I should see the pings table:
      | Status |                              |
      | 200    | Jan  1, 2011 at 12:10:00 AM UTC |

    And I refresh the page after 6 minutes
    Then I should see "Next ping in 2 minutes."
    And I should see the pings table:
      | Status |                              |
      | 200    | Jan  1, 2011 at 12:10:00 AM UTC |



  Scenario: Pings are ordered newest first
    When I create the URL:
      | URL     | http://example.com |
      | Seconds | 600                |
    And I refresh the page after 30 minutes
    Then I should see the pings table:
      | Status |                              |
      | 200    | Jan  1, 2011 at 12:30:00 AM UTC |
      | 200    | Jan  1, 2011 at 12:20:00 AM UTC |
      | 200    | Jan  1, 2011 at 12:10:00 AM UTC |



  Scenario: Viewing the URLs
    When I create the URLs:
      | Title  | URL               | HTTP method | Seconds |
      | Google | http://google.com | GET         | 400     |
      | Yahoo! | http://yahoo.com  | POST        | 600     |
    And I go to the home page
    Then I should see the URLs table:
      | Title  | URL               | HTTP method | Seconds |
      | Yahoo! | http://yahoo.com  | POST        | 600     |
      | Google | http://google.com | GET         | 400     |

    When I create the URL:
      | Title       | Example            |
      | URL         | http://example.com |
      | Seconds     | 100                |
      | HTTP method | GET                |
    And I go to the home page
    Then I should see the URLs table:
      | Title   | URL                | HTTP method | Seconds |
      | Example | http://example.com | GET         | 100     |
      | Yahoo!  | http://yahoo.com   | POST        | 600     |
      | Google  | http://google.com  | GET         | 400     |



  Scenario: Viewing previously created URLs
    When I create the URLs:
      | Title  | URL               | HTTP method | Seconds |
      | Google | http://google.com | GET         | 400     |
      | Yahoo! | http://yahoo.com  | POST        | 600     |
    And I go to the home page
    And I follow "Google"
    Then I should see "GET request to http://google.com"