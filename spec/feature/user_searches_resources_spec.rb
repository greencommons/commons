require 'rails_helper'

RSpec.feature 'Searching for resources', :worker, :elasticsearch do
  context 'when searching by title' do
    scenario 'users can find a resource when searching' do
      title = Faker::Hipster.sentence
      metadata = { creators: 'Rachel Carson', date: Time.zone.today }
      create(:resource, title: title, metadata: metadata)
      wait_for { Resource.search(title).results.total }.to eq(1)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        click_button 'Search'
      end

      expect(page).to have_text(title)
    end

    scenario 'users should see updated search results' do
      title = 'Twitter'
      new_title = 'Facebook'
      metadata = { creators: 'Rachel Carson', date: Time.zone.today }

      resource = create(:resource, title: title, metadata: metadata)

      wait_for { Resource.search(title).results.total }.to eq(1)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        click_button 'Search'
      end
      expect(page).to have_text(title)

      resource.title = new_title
      resource.save!
      wait_for { Resource.search(new_title).results.total }.to eq(1)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: new_title
        click_button 'Search'
      end

      expect(page).to have_text(new_title)
    end

    scenario "users should see updated search results even if the record wasn't indexed" do
      title = 'Spotify'
      new_title = 'Deezer'
      metadata = { creators: 'Rachel Carson', date: Time.zone.today }

      resource = create(:resource, title: title, metadata: metadata)

      wait_for { Resource.search(title).results.total }.to eq(1)
      RemoveFromIndexJob.new.perform('Resource', resource.id)

      expect_any_instance_of(SearchIndex).to receive(:update).once.and_call_original
      expect_any_instance_of(SearchIndex).to receive(:add).once.and_call_original

      resource.title = new_title
      resource.save!
      wait_for { Resource.search(new_title).results.total }.to eq(1)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: new_title
        click_button 'Search'
      end

      expect(page).to have_text(new_title)
    end

    scenario 'users can search for resources, groups and lists' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource")
      create(:group, name: "#{title} My Group")
      create(:list, name: "#{title} My List")

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Group, List]).results.total
      end.to eq(3)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        click_button 'Search'
      end

      expect(page).to have_text('My Resource')
      expect(page).to have_text('My Group')
      expect(page).to have_text('My List')
    end

    scenario 'users cannot see search results for deleted files' do
      title = Faker::Hipster.sentence
      metadata = { creators: 'Rachel Carson', date: Time.zone.today }
      resource = create(:resource, title: title, metadata: metadata)
      wait_for { Resource.search(title).results.total }.to eq(1)
      resource.destroy!
      wait_for { Resource.search(title).results.total }.to eq(0)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        click_button 'Search'
      end

      expect(page).not_to have_text(title)
    end
  end

  context 'filtering' do
    scenario 'users can filter by model' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource")
      create(:group, name: "#{title} My Group")
      create(:list, name: "#{title} My List")

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Group, List]).results.total
      end.to eq(3)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        click_button 'Search'
      end

      expect(page).to have_text('My Resource')
      expect(page).to have_text('My Group')
      expect(page).to have_text('My List')

      uncheck('Resources')
      uncheck('Lists')
      click_button 'FILTER'

      expect(page).not_to have_text('My Resource')
      expect(page).not_to have_text('My List')
      expect(page).to have_text('My Group')
    end

    scenario 'users can filter by resource type' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource", resource_type: :article)

      wait_for do
        Elasticsearch::Model.search(title, [Resource]).results.total
      end.to eq(1)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        click_button 'Search'
      end

      expect(page).to have_text('My Resource')

      uncheck('Articles')
      click_button 'FILTER'

      expect(page).not_to have_text('My Resource')
    end
  end

  context 'sorting' do
    scenario 'users can sort by created_at date' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource", created_at: 10.days.ago)
      create(:group, name: "#{title} My Group", created_at: 5.days.ago)
      create(:list, name: "#{title} My List", created_at: 8.days.ago)

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Group, List]).results.total
      end.to eq(3)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        click_button 'Search'
      end

      select 'DATE', from: 'sort'
      click_button 'SORT'

      expect(page).to have_text(/.*My Group.*My List.*My Resource.*/)
    end
  end
end
