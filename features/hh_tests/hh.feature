Feature: Test feature for My Office

  Background:
    Given hh.ru site is opened

  Scenario: Search for My Office
    When I open advanced search menu
    And I select to search only in company name
    And I add next text to the keywords field: мой офис
    And I click Find button
    And I switch to the Companies tab
    Then I should see МойОфис in the companies list

  Scenario: Number of vacancies for My Office in the current region
    When I open page for company: МойОфис
    Then Amount of vacancies in the current region should be more than 0

  Scenario: Vacation for QA Automation Engineer for My Office in the current region
    When I open page for company: МойОфис
    And I expand all lists for the current region
    Then I should see vacancy: QA Automation Engineer