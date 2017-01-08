module LoginHelpers
  def feature_login
    user = create(:user, email: 'admin@greencommons.org', password: 'thecommons')
    visit new_user_session_path

    within('#new_user') do
      fill_in 'user[email]', with: 'admin@greencommons.org'
      fill_in 'user[password]', with: 'thecommons'
      click_button 'Log in'
    end

    user
  end
end

RSpec.configure do |c|
  c.include LoginHelpers
end
