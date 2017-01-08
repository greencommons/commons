require 'rails_helper'

RSpec.feature 'Managing groups' do

  def login
    create(:user, email: 'admin@greencommons.org', password: 'thecommons')
    visit new_user_session_path

    within('#new_user') do
      fill_in 'user[email]', with: 'admin@greencommons.org'
      fill_in 'user[password]', with: 'thecommons'
      click_button 'Log in'
    end
  end

  scenario 'users can create a group' do
    login
    group = build(:group)

    click_link 'Create Group'
    expect(find('h1')).to have_content('Create Group')
    within('#new_group') do
      fill_in 'group[name]', with: group.name
      fill_in 'group[short_description]', with: group.short_description
      fill_in 'group[long_description]', with: group.long_description
      fill_in 'group[url]', with: group.url
      fill_in 'group[email]', with: 'admin@greencommons.org'
      click_on 'CREATE'
    end
    expect(find('h1')).to have_content(group.name)
  end

  scenario 'users can update a group' do
    login
    group = create(:group)

    visit group
    click_on 'Settings'
    expect(find('h1')).to have_content("Edit #{group.name}")

  end

  scenario 'users can destroy a group'
  scenario 'users can add members'
  scenario 'users can remove members'
  scenario 'users can make other members admins'
  scenario 'users can remove admin from other members'

end
