@d8 @api
Feature: Override administrator approval

  Scenario: Can configure administrator approval override
    Given the "raven_override_administrator_approval" variable is set to "0"
    And I am logged in as the admin user
    And I am on "/admin/config/people/raven"
    When I check "Enable administrator approval override"
    And I press "Save configuration"
    Then the "raven_override_administrator_approval" variable should be "1"

  Scenario: Lets Raven users create accounts when administrator approval is overridden
    Given the "dblog" module is enabled
    And the config "register" of "user.settings" variable is set to "visitors_admin_approval"
    And the "raven_override_administrator_approval" variable is set to "1"
    When I log in to Raven as "test0001"
    And I should see "Log out"
    And I should see an "notice" "raven" Watchdog message "New user: test0001 (test0001@cam.ac.uk)."

  Scenario: Doesn't let normal users create accounts when administrator approval is overridden for Raven
    Given the config "register" of "user.settings" variable is set to "visitors_admin_approval"
    And the "raven_override_administrator_approval" variable is set to "1"
    And I am on "/user/register"
    When I fill in "Username" with "user"
    And I fill in "Email address" with "test@example.com"
    And I press "Create new account"
    Then I should see "Thank you for applying for an account. Your account is currently pending approval by the site administrator."
