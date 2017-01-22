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
      expect(page).to have_text(metadata[:creators])
      expect(page).to have_text(metadata[:date])
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
      title = 'Twitter'
      new_title = 'Facebook'
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
      expect(page).to have_text(metadata[:creators])
      expect(page).to have_text(metadata[:date])
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
end
