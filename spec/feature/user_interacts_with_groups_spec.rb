require 'rails_helper'

RSpec.feature 'Interacting with groups' do
  scenario 'users can join an existing group' do
    user = feature_login
    group = create(:group)

    visit group_path(group)
    click_on 'JOIN GROUP'

    expect(group.find_member(user)).not_to be nil
    expect(page).to have_content('LEAVE GROUP')
  end

  scenario 'users can leave an existing group' do
    user = feature_login
    group = create(:group)
    group.add_user(user)

    visit group_path(group)
    click_on 'LEAVE GROUP'

    expect(group.find_member(user)).to be nil
    expect(page).to have_content('JOIN GROUP')
  end

  scenario 'users can\'t edit groups' do
    user = feature_login
    group = create(:group)

    group.add_user(user)

    visit group_path(group)
    click_on 'SETTINGS'

    expect(page).to have_content('You are not authorized to perform this action.')
  end

  scenario 'users can\'t access edit group page' do
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
