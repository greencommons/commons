require 'rails_helper'

RSpec.feature 'Interacting with networks' do
  scenario 'users can join an existing network' do
    user = feature_login
    network = create(:network)

    visit network_path(network)
    click_on 'Join network'
    wait_for_ajax

    expect(network.find_member(user)).not_to be nil
    expect(page).to have_content('Leave network')
  end

  scenario 'users can leave an existing network' do
    user = feature_login
    network = create(:network)
    network.add_user(user)

    visit network_path(network)
    click_on 'Leave network'
    wait_for_ajax

    expect(network.find_member(user)).to be nil
    expect(page).to have_content('Join network')
  end

  scenario 'users can\'t edit networks' do
    user = feature_login
    network = create(:network)

    network.add_user(user)

    visit network_path(network)
    expect(page).not_to have_content('Settings')
  end

  scenario 'users can\'t edit members list' do
    user = feature_login
    network = create(:network)
    new_user = create(:user)

    network.add_user(user)
    network.add_user(new_user)

    visit network_members_path(network)

    expect(page).to have_no_css('#user-autocomplete-email')
    expect(page).not_to have_content('MAKE ADMIN')
    expect(page).not_to have_content('REMOVE')
  end
end
