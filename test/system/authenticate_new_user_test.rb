# frozen_string_literal: true

require 'application_system_test_case'

class AuthenticateNewUserTest < ApplicationSystemTestCase
  test 'sign up new admin user and login' do
    # Getting Started registration
    visit '/getting_started'

    fill_in 'Username', with: 'Rob'
    fill_in 'Email', with: 'rob@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Confirm Password', with: 'password'
    click_button 'Finish'

    # Login screen
    assert_selector 'div.notice', text: 'Getting Started finished Successfully. You can now login to the appliance.'
    assert_selector 'h4', text: 'Mailserver Administration'

    fill_in 'Username', with: 'Rob'
    fill_in 'Password', with: 'password'
    click_button 'Login'

    # Dashboard
    assert_selector 'h2', text: 'System Overview'
  end
end
