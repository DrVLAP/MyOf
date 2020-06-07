Given /^(.*?) site is opened$/ do |site|
  visit("http://#{site}")
end

Given /^I open page for company: (.*?)$/ do |name|
  step 'I open advanced search menu'
  step "I add next text to the keywords field: #{name}"
  step 'I click Find button'
  step 'I switch to the Companies tab'
  find('td.b-companylist div a', text: name).click
end

When(/^I open advanced search menu$/) do
  find(ADVANCED_SEARCH).click
end

When /^I (de)?select to search only in (vacancy name|company name|vacancy description)$/ do |deselect, field|
  deselect = if deselect == ''
               FALSE
             else
               TRUE
             end

  field = case field
          when 'vacancy name'
            'name'
          when 'company name'
            'company_name'
          when 'vacancy description'
            'description'
          end
  page.document.synchronize do
    find("label[data-qa*='#{field}']").set(deselect)
  end
end

When /^I add next text to the keywords field: (.*?)$/ do |text|
  find("input[data-qa*='keywords-input']").set(text)
end

When /^I click Find button$/ do ||
  find("input[data-qa*='submit']").click
end

When /^I switch to the (Vacancies|CV|Companies) tab$/ do |tab|
  tab = case tab
        when 'Vacancies'
          'searchVacancy'
        when 'CV'
          'resumeSearch'
        else
          'employersList'
        end
  find("div[data-hh-tab-id=#{tab}]").click
end

When /^I expand all lists for the current region$/ do
  # Block is needed to check what section is expanded
  # And to try to expand it
  # sleep for waiting for page update, sycnhronize is a better idea
  all('div.company-vacancies-group').each do |block|
    unless block.has_css?('company-vacancies-group_expanded')
      within(block) do
        find('span.bloko-link-switch').click
      end
      sleep 1
    end
  end
end

Then /^I should see (.*?) in the companies list$/ do |name|
  expect(page).to have_css('a', text: name)
end

# This step can be done in two ways, because currently looks like there is a bug on hh.ru
# I selected to just get value from page, but more correct way was to count elements on page, because it was faster
Then /^Amount of vacancies in the current region should be more than (\d+)$/ do |number|
  expect(first('span.company-vacancies-hint').text.to_i).to be > number
end

Then /^I should see vacancy: (.*?)$/ do |vacancy|
  expect(page).to have_xpath("//A[@data-qa='vacancy-serp__vacancy-title'][text()='#{vacancy}']")
end