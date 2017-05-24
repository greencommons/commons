require 'rails_helper'

RSpec.feature 'Managing lists', :worker, :elasticsearch do
  scenario 'users can list lists' do
    user = feature_login
    list = create(:list, owner: user, description: 'Some description.')

    click_on 'Hello,'
    click_link 'My Lists'
    expect(find('h1')).to have_content('My Lists')
    expect(page).to have_text(list.name)
  end

  scenario 'users can view a list' do
    user = feature_login
    list = create(:list, owner: user, description: 'Some description.')

    click_on 'Hello,'
    click_link 'My Lists'
    click_link list.name

    expect(page).to have_text('Some description.')
  end

  scenario 'users can create a list' do
    user = feature_login

    find(:css, '.glyphicon.glyphicon-plus').click
    click_link 'Create List'

    within('#new_list') do
      fill_in 'list[name]', with: 'My list'
      fill_in 'list[description]', with: 'Description!'
      find('.bootstrap-tagsinput').find('input').set('some,random,tags')
      click_on 'Create'
    end

    expect(find('h1')).to have_content('My list')
    expect(List.count).to eq 1
    expect(List.first.owner).to eq user
    expect(List.first.privacy).to eq 'publ'
    expect(page).to have_content('some')
    expect(page).to have_content('random')
    expect(page).to have_content('tags')
  end

  scenario 'users can create a private list' do
    feature_login

    find(:css, '.glyphicon.glyphicon-plus').click
    click_link 'Create List'

    within('#new_list') do
      fill_in 'list[name]', with: 'My list'
      fill_in 'list[description]', with: 'Description!'
      find(:css, '#list_privacy').set(true)
      click_on 'Create'
    end

    expect(find('h1')).to have_content('My list')
    expect(List.count).to eq 1
    expect(List.first.privacy).to eq 'priv'
  end

  scenario 'users can update a list' do
    user = feature_login
    list = create(:list, owner: user, description: 'Some description.')

    visit edit_list_path(list)
    within("#edit_list_#{list.id}") do
      fill_in 'list[name]', with: 'Water Experiments'
      find('.bootstrap-tagsinput').find('input').set('some,tags')
      click_on 'Update'
    end

    expect(find('h1')).to have_content('Water Experiments')
    expect(List.last.name).to eq 'Water Experiments'
    expect(page).to have_content('some')
    expect(page).to have_content('tags')
  end

  scenario 'users can destroy a list' do
    user = feature_login
    list = create(:list, owner: user, description: 'Some description.')

    visit list_path(list)
    click_link 'Delete'
    wait_for_ajax

    expect(List.count).to eq 0
  end

  scenario 'sort by creation date' do
    user = feature_login
    list = create(:list, owner: user, description: 'Some description.')

    group1 = create(:group, name: 'Group 1', published_at: 3.days.ago)
    group2 = create(:group, name: 'Group 2', published_at: 1.days.ago)
    resource = create(:resource, title: 'Resource', published_at: 10.days.ago)

    create(:lists_item, list: list, item: group1, published_at: group1.published_at)
    create(:lists_item, list: list, item: group2, published_at: group2.published_at)
    create(:lists_item, list: list, item: resource, published_at: resource.published_at)

    visit list_path(list)
    expect(page).to have_text(group1.name)
    expect(page).to have_text(group2.name)
    expect(page).to have_text(resource.title)

    expect(page).to have_text(/.*Group 2.*Group 1.*Resource.*/)
    select 'Sort by creation date', from: 'sort'
    wait_for_ajax
    expect(page).to have_text(/.*Resource.*Group 2.*Group 1.*/)
  end

  context 'remove from list' do
    scenario 'users can remove a group from a list' do
      user = feature_login
      list = create(:list, owner: user, description: 'Some description.')

      group1 = create(:group, name: 'Group 1', published_at: 3.days.ago)
      group2 = create(:group, name: 'Group 2', published_at: 1.days.ago)
      resource = create(:resource, title: 'Resource', published_at: 10.days.ago)

      create(:lists_item, list: list, item: group1)
      create(:lists_item, list: list, item: group2)
      create(:lists_item, list: list, item: resource)

      visit list_path(list)
      expect(page).to have_text(group1.name)
      expect(page).to have_text(group2.name)
      expect(page).to have_text(resource.name)

      first('.summary-card__body').hover
      find('.summary-card__delete').click
      wait_for_ajax

      expect(page).not_to have_text(group1.name)
      expect(page).to have_text(group2.name)
      expect(page).to have_text(resource.name)
    end

    scenario 'users can remove a resource from a list' do
      user = feature_login
      list = create(:list, owner: user, description: 'Some description.')

      resource1 = create(:resource, title: 'Resource 1', published_at: 10.days.ago)
      resource2 = create(:resource, title: 'Resource 2', published_at: 10.days.ago)

      create(:lists_item, list: list, item: resource1)
      create(:lists_item, list: list, item: resource2)

      visit list_path(list)
      expect(page).to have_text(resource1.name)
      expect(page).to have_text(resource2.name)

      first('.summary-card__body').hover
      find('.summary-card__delete').click
      wait_for_ajax

      expect(page).not_to have_text(resource1.name)
      expect(page).to have_text(resource2.name)
    end
  end
end
