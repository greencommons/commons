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
        find('.navbar__search-button').click
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
        find('.navbar__search-button').click
      end
      expect(page).to have_text(title)

      resource.title = new_title
      resource.save!
      wait_for { Resource.search(new_title).results.total }.to eq(1)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: new_title
        find('.navbar__search-button').click
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
        find('.navbar__search-button').click
      end

      expect(page).to have_text(new_title)
    end

    scenario 'users can search for resources, networks and lists' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource")
      create(:network, name: "#{title} My Network")
      create(:list, name: "#{title} My List")

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Network, List]).results.total
      end.to eq(3)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        find('.navbar__search-button').click
      end

      expect(page).to have_text('My Resource')
      expect(page).to have_text('My Network')
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
        find('.navbar__search-button').click
      end

      expect(page).to have_text('No results found')
    end
  end

  context 'filtering' do
    scenario 'users can filter by model', js: true do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource")
      create(:network, name: "#{title} My Network")
      create(:list, name: "#{title} My List")

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Network, List]).results.total
      end.to eq(3)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        find('.navbar__search-button').click
      end

      expect(page).to have_text('My Resource')
      expect(page).to have_text('My Network')
      expect(page).to have_text('My List')

      uncheck('Resources')
      wait_for_ajax
      uncheck('Lists')
      wait_for_ajax

      expect(page).not_to have_text('My Resource')
      expect(page).not_to have_text('My List')
      expect(page).to have_text('My Network')
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
        find('.navbar__search-button').click
      end

      expect(page).to have_text('My Resource')

      uncheck('Articles')

      expect(page).not_to have_text('My Resource')
    end
  end

  context 'sorting' do
    scenario 'users can sort by newest first' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource", created_at: 10.days.ago)
      create(:network, name: "#{title} My Network", created_at: 5.days.ago)
      create(:list, name: "#{title} My List", created_at: 8.days.ago)

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Network, List]).results.total
      end.to eq(3)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        find('.navbar__search-button').click
      end

      select 'Newest First', from: 'sort'
      wait_for_ajax

      expect(page).to have_text(/.*My Network.*My List.*My Resource.*/)
    end

    scenario 'users can sort by oldest first' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource", created_at: 10.days.ago)
      create(:network, name: "#{title} My Network", created_at: 5.days.ago)
      create(:list, name: "#{title} My List", created_at: 8.days.ago)

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Network, List]).results.total
      end.to eq(3)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        find('.navbar__search-button').click
      end

      select 'Oldest First', from: 'sort'
      wait_for_ajax

      expect(page).to have_text(/.*My Resource.*My List.*My Network.*/)
    end
  end

  context 'related records' do
    scenario 'users can see related records' do
      resource = create(:resource, title: 'My Resource')
      protection_network = create(:network, name: 'Protection Network')
      help_network = create(:network, name: 'Help Network')
      helpful_list = create(:list, name: 'Helpful List')

      resource.tag_list.add('ocean')
      resource.tag_list.add('sky')
      resource.save!

      protection_network.tag_list.add('ocean')
      protection_network.save!

      help_network.tag_list.add('mountain')
      help_network.save!

      helpful_list.tag_list.add('sky')
      helpful_list.save!

      wait_for do
        Suggesters::Tags.new(tags: %w(ocean sky)).suggest.size
      end.to eq(3)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: 'My Resource'
        find('.navbar__search-button').click
      end

      expect(page).to have_text('My Resource')
      expect(page).to have_text('You may also like...')
      expect(page).to have_text('Protection Network')
      expect(page).to have_text('Helpful List')
      expect(page).not_to have_text('Help Network')
    end
  end
end
