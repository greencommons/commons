require 'rails_helper'

RSpec.feature 'Managing groups' do
  scenario 'users can create a group' do
    feature_login
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

  scenario 'group admins can update a group' do
    user = feature_login
    group = create(:group)
    group.add_admin(user)

    visit group_path(group)
    click_on 'SETTINGS'
    expect(find('h1')).to have_content("Edit #{group.name}")

    within("#edit_group_#{group.id}") do
      fill_in 'group[name]', with: group.name
      fill_in 'group[short_description]', with: 'New Description.'

      click_on 'UPDATE'
    end

    expect(find('h1')).to have_content(group.name)
    expect(page).to have_text('New Description.')
  end

  scenario 'group admins can add and remove members' do
    user = feature_login
    group = create(:group)
    group.add_admin(user)

    new_member = create(:user)

    visit group_path(group)
    click_on 'MEMBERS'

    within('#top-page-form') do
      fill_in 'email', with: new_member.email
      click_on 'add-member-button'
    end

    expect(page).to have_text(new_member.email)

    click_on 'REMOVE'
    expect(page).not_to have_text(new_member.email)
  end

  scenario 'group admins can add or remove admin rights' do
    user = feature_login
    group = create(:group)
    group.add_admin(user)

    new_member = create(:user)
    group.add_user(new_member)

    visit group_path(group)
    click_on 'MEMBERS'

    expect(page).to have_text('2 members')

    click_on 'MAKE ADMIN'
    expect(group.admin?(new_member)).to be true

    click_on 'REMOVE ADMIN'
    expect(group.admin?(new_member)).to be false
  end
end
