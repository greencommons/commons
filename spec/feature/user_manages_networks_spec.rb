require 'rails_helper'

RSpec.feature 'Managing networks' do
  scenario 'users can create a network' do
    feature_login
    network = build(:network)

    find(:css, '.glyphicon.glyphicon-plus').click
    click_link 'Create Network'
    expect(find('h1')).to have_content('Create Network')
    within('#new_network') do
      fill_in 'network[name]', with: network.name
      fill_in 'network[short_description]', with: network.short_description
      fill_in 'network[long_description]', with: network.long_description
      find('.bootstrap-tagsinput').find('input').set('some,random,tags')
      click_on 'Create'
    end

    expect(find('h1')).to have_content(network.name)
    expect(page).to have_content('some')
    expect(page).to have_content('random')
    expect(page).to have_content('tags')
  end

  scenario 'network admins can update a network' do
    user = feature_login
    network = create(:network)
    network.tag_list.add('test')
    network.add_admin(user)

    visit network_path(network)
    click_on 'Settings'
    expect(find('h1')).to have_content("Edit #{network.name}")

    within("#edit_network_#{network.id}") do
      fill_in 'network[name]', with: network.name
      fill_in 'network[short_description]', with: 'New Description.'
      find('.bootstrap-tagsinput').find('input').set('some,tags')

      click_on 'Update'
    end

    expect(find('h1')).to have_content(network.name)
    expect(page).to have_text('New Description.')

    expect(page).to have_content('some')
    expect(page).to have_content('tags')
  end

  scenario 'network admins can add and remove members' do
    user = feature_login
    network = create(:network)
    network.add_admin(user)

    new_member = create(:user)

    visit network_path(network)
    click_on '1'

    within('#top-page-form') do
      fill_in 'email', with: new_member.email
      click_on 'add-member-button'
    end

    expect(page).to have_text(new_member.email)

    click_on 'Remove'
    expect(page).not_to have_text(new_member.email)
  end

  scenario 'network admins can add or remove admin rights' do
    user = feature_login
    network = create(:network)
    network.add_admin(user)

    new_member = create(:user)
    network.add_user(new_member)

    visit network_path(network)
    click_on '2'

    expect(page).to have_text('2 members')

    click_on 'Make admin'
    wait_for_ajax
    expect(network.admin?(new_member)).to be true

    click_on 'Remove admin rights'
    wait_for_ajax
    expect(network.admin?(new_member)).to be false
  end

  scenario 'user can create a list with the network as the owner' do
    network = create(:network)
    feature_login
    visit network_path(network)
    click_on 'New list'
    expect(find('div[data-react-class="OwnerPicker"]')['data-react-props']).
      to be_include("Network:#{network.id}")
  end
end
