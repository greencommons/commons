require 'rails_helper'

RSpec.feature 'Searching for resources', :worker, :elasticsearch do
  context 'when searching by title' do
    scenario 'users should see metadata for a resource when search' do
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

    scenario 'users should not see search results for deleted files' do
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
      expect(page).not_to have_text(metadata[:creators])
      expect(page).not_to have_text(metadata[:date])
    end
  end
end
