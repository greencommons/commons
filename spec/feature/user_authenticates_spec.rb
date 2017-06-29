require 'rails_helper'

RSpec.feature 'Authentication' do
  scenario 'users can login' do
    create(:user, first_name: 'John',
                  email: 'admin@greencommons.org',
                  password: 'thecommons')
    visit new_user_session_path

    within('#new_user') do
      fill_in 'user[email]', with: 'admin@greencommons.org'
      fill_in 'user[password]', with: 'thecommons'
      click_button 'Log in'
    end

    expect(page).to have_text('Hello, John')
  end

  scenario 'users can logout' do
    create(:user, first_name: 'admin', email: 'admin@greencommons.org', password: 'thecommons')
    visit new_user_session_path

    within('#new_user') do
      fill_in 'user[email]', with: 'admin@greencommons.org'
      fill_in 'user[password]', with: 'thecommons'
      click_button 'Log in'
    end

    click_link 'Hello, admin'
    click_link 'Logout'
    expect(page).not_to have_text('Hello, admin')
  end
end
