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
      expect(page).to have_css('a.btn-add-to-list')
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
      expect(page).to have_css('a.btn-add-to-list')
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

  context 'tags' do
    scenario 'users can search for resources, networks and lists' do
      title = Faker::Hipster.sentence

      resource = create(:resource, title: "Resource #{title}")
      network = create(:network, name: "Network #{title}")

      resource.tag_list.add('ocean')
      resource.tag_list.add('sky')
      resource.save!

      network.tag_list.add('earth')
      network.tag_list.add('cloud')
      network.save!

      wait_for do
        Elasticsearch::Model.search('ocean', [Resource]).results.total
      end.to eq(1)

      wait_for do
        Elasticsearch::Model.search('earth', [Network]).results.total
      end.to eq(1)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: 'ocean'
        find('.navbar__search-button').click
      end

      expect(page).to have_text("Resource #{title}")
      expect(page).not_to have_text("Network #{title}")
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
      expect(page).to have_css('a.btn-add-to-list')
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

      expect(page).to have_css('a.btn-add-to-list')
      expect(page).not_to have_text('My Resource')
    end

    scenario 'users can filter by date' do
      title = Faker::Hipster.sentence

      create(
        :resource,
        title: "#{title} My Resource",
        resource_type: :article,
        created_at: 3.days.from_now
      )

      wait_for do
        Elasticsearch::Model.search(title, [Resource]).results.total
      end.to eq(1)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        find('.navbar__search-button').click
      end

      expect(page).to have_text('My Resource')
      expect(page).to have_css('a.btn-add-to-list')

      daterange = find('input[name=daterange]')
      daterange.set('date-start' => 5.months.ago.to_i)
      daterange.set('date-end' => 3.months.ago.to_i)
      daterange.click
      find('.applyBtn').click
      wait_for_ajax

      expect(page).not_to have_text('My Resource')
    end

    scenario 'users can see filtered resources by date' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource", resource_type: :article,
                        published_at: Time.parse('02-01-2017'))
      create(:resource, title: "#{title} My Other Resource", resource_type: :article,
                        published_at: Time.parse('09-01-2017'))

      wait_for do
        Elasticsearch::Model.search(title, [Resource]).results.total
      end.to eq(2)

      # Searching between 01/01/2017 and 07/01/2017
      visit search_path(query: title, filters: { start: '1483225200', end: '1483829999' })

      expect(page).to have_text('My Resource')
      expect(page).not_to have_text('My Other Resource')
      expect(page).to have_css('a.btn-add-to-list')
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
      expect(page).to have_css('a.btn-add-to-list')
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

  context 'when user search for resource using the search bar located below the nav bar' do
    scenario 'users can search for resources, networks and lists' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource")
      create(:network, name: "#{title} My Network")
      create(:list, name: "#{title} My List")

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Network, List]).results.total
      end.to eq(3)

      visit search_path
      within('.search-remote-form') do
        fill_in 'query', with: title
        find('button').click
      end

      expect(page).to have_text("#{title} My Resource")
      expect(page).to have_text("#{title} My Network")
      expect(page).to have_text("#{title} My List")
    end

    scenario 'users can search and keep the filters' do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource")
      create(:resource, title: "#{title} Article", resource_type: :article)

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Network, List]).results.total
      end.to eq(2)

      visit search_path
      within('.search-remote-form') do
        fill_in 'query', with: title
        find('button').click
      end

      expect(page).to have_text("#{title} Article")
      uncheck('Articles')

      expect(page).to have_text("#{title} My Resource")
      expect(page).not_to have_text("#{title} Article")

      within('.search-remote-form') do
        fill_in 'query', with: 'Article'
        find('button').click
      end
      expect(page).not_to have_text("#{title} Article")
    end
  end
end
