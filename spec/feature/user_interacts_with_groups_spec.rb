require 'rails_helper'

RSpec.feature 'Interacting with groups' do
  scenario 'users can join an existing group' do
    user = feature_login
    group = create(:group)

    visit group_path(group)
    click_on 'Join group'
    wait_for_ajax

    expect(group.find_member(user)).not_to be nil
    expect(page).to have_content('Leave group')
  end

  scenario 'users can leave an existing group' do
    user = feature_login
    group = create(:group)
    group.add_user(user)

    visit group_path(group)
    click_on 'Leave group'
    wait_for_ajax

    expect(group.find_member(user)).to be nil
    expect(page).to have_content('Join group')
  end

  scenario 'users can\'t edit groups' do
    user = feature_login
    group = create(:group)

    group.add_user(user)

    visit group_path(group)
    expect(page).not_to have_content('Settings')
  end

  scenario 'users can\'t edit members list' do
    user = feature_login
    group = create(:group)
    new_user = create(:user)

    group.add_user(user)
    group.add_user(new_user)

    visit group_members_path(group)

    expect(page).to have_no_css('#user-autocomplete-email')
    expect(page).not_to have_content('MAKE ADMIN')
    expect(page).not_to have_content('REMOVE')
  end
end
