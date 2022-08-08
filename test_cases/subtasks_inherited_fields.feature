Feature: Subtasks configurable inherited fields
  In order to insert subtasks fast
  As a Redmine user
  I want subtasks to inherit some configurable fields from parent issue

  Scenario: Configure plugin
    Given I have logged in as an admin user
    And I have gone to redmine_subtasks_inherited_fields plugin config page
    And I see a form with 9 checkboxes
    When I check Inherit parent Target version
    And I check Inherit parent Tracker
    And I press in Apply
    Then the settings are saved
    And a "Successful update." message is displayed
    And the Default subtask Tracker select is hidden 

  Scenario: Configure plugin with default subtask Tracker
    Given I have logged in as an admin user
    And I have gone to redmine_subtasks_inherited_fields plugin config page
    And I see a form with 9 checkboxes
    When I uncheck Inherit parent Tracker
    And I see Default subtask Tracker select
    And I select Task tracker in Default subtask Tracker select
    And I press in Apply
    Then the settings are saved
    And a "Successful update." message is displayed
    And the Default subtask Tracker select is still shown

  Scenario: Unauthorized access to plugin config page
    Given I have logged in as an average user
    When I go to redmine_subtasks_inherited_fields plugin config page
    Then I should see "You are not authorized to access this page." message
    And I should not see any checkbox
 
  Scenario: Open subtask form from issue with all inherit options enabled
    Given All checkboxes have been checked in redmine_subtasks_inherited_fields plugin config page
    And the settings were saved
    And I have logged in as an user with permission to a project
    And the project has at least 1 private issue
    And I go to that issue page
    And I see Target version has a value
    And I see Start date has a value
    And I see Due date has a value
    And I see Tracker has a value
    And I see Priority has a value
    And I see Category has a value
    And I see Assignee has a value
    And I see Status has a value
    And I see Estimated Hours has a value
    And I see that the issue is private
    When I follow "Add" link in subtasks section
    Then I should see the create new issue form
    And I should see parent id in Parent task textfield
    And I should see the private checkbox checked
    And I should see Target version select with the same value as parent Target version
    And I should see Start date textfield with the same value as parent Start date
    And I should see Due date textfield with the same value as parent Due date
    And I should see Tracker select with the same value as parent Tracker
    And I should see Priority select with the same value as parent Priority
    And I should see Category select with the same value as parent Category
    And I should see Assignee select with the same value as parent Assignee
    And I should see Status select with the same value as parent Status
    And I should see Estimated Hours select with the same value as parent Estimated Hours

  Scenario: Open subtask form from issue with all inherit options disabled
    Given All checkboxes have been unchecked in redmine_subtasks_inherited_fields plugin config page
    And I have selected "Task" tracker in Default subtask Tracker select
    And the settings were saved
    And I have logged in as an user with permission to a project
    And the project has at least 1 private issue where tracker is not "Task"
    And I go to that issue page
    And I see Target version has a value
    And I see Start date has a value
    And I see Due date has a value
    And I see Tracker has a value different from "Task"
    And I see Priority has a value
    And I see Category has a value
    And I see Assignee has a value
    And I see Status has a value
    And I see Estimated Hours has a value
    And I see that the issue is private
    When I follow "Add" link in subtasks section
    Then I should see the create new issue form
    And I should see parent id in Parent task textfield
    And I should see the private checkbox unchecked
    And I should see Target version select with empty value selected
    And I should see Start date textfield with today's date
    And I should see Due date textfield with empty value
    And I should see Tracker select with the value "Task"
    And I should see Priority select with the default priority value selected
    And I should see Category select with empty value selected
    And I should see Assignee select with empty value selected
    And I should see Status select with the default status value selected
    And I should see Estimated Hours select with empty value selected
