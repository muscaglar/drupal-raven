@d8 @api
Feature: Login message

  Scenario Outline: Login page message
    When I go to "<path>"
    And the config "register" of "user.settings" variable is set to "visitors"
    Then I should see "Log in with Raven" in the ".region-content form .form-actions a" element
    When I follow "Log in with Raven"
    Then I should be on "https://demo.raven.cam.ac.uk/auth/authenticate.html"

  Examples:
    | path           |
    | /user          |
    | /user/register |
    | /user/login    |

  Scenario: User login block message
    Given the "block" module is enabled
#    And the "user" "login" block is in the "sidebar_first" region
    And I am on "/"
    Then I should see "Log in with Raven" in the "#block-userlogin" element
    When I follow "Log in with Raven"
    Then I should be on "https://demo.raven.cam.ac.uk/auth/authenticate.html"

  Scenario: After Raven login redirects to current page
    Given the "raven_override_administrator_approval" variable is set to "TRUE"
    And I am on "/user"
    And I follow "Log in with Raven"
    And I fill in "User-id" with "test0001"
    And I fill in "Password" with "test"
    And I press "Submit"
    Then I should be on "/"

  Scenario: After Raven login redirects to destination page
    Given the "raven_override_administrator_approval" variable is set to "TRUE"
    When I go to "/raven/login?back_path=foo"
    And I fill in "User-id" with "test0001"
    And I fill in "Password" with "test"
    And I press "Submit"
    Then I should be on "/foo"

  Scenario: After Raven login redirects to the homepage when the destination page is not a relative URL
    Given the "raven_override_administrator_approval" variable is set to "TRUE"
    When I go to "/raven/login?back_path=http://www.cam.ac.uk/"
    And I fill in "User-id" with "test0001"
    And I fill in "Password" with "test"
    And I press "Submit"
    Then I should be on the homepage

  Scenario: Raven login available when in maintenance mode
    Given the state "system.maintenance_mode" is set to "1"
    And the "authenticated" role has the "system" "access site in maintenance mode" permission
    And there is a user called "test0001" with the email address "test0001@example.com"
    When I go to "/raven/login"
    And I fill in "User-id" with "test0001"
    And I fill in "Password" with "test"
    And I press "Submit"
    Then I should see "Log out"
    And I should see "Operating in maintenance mode"
