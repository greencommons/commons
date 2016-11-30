require 'rails_helper'

RSpec.feature 'Searching for resources', :worker do
  context 'when searching by title' do
    scenario 'users should see metadata for a resource when search' do
      title = 'Silent Spring'
      metadata = { author: 'Rachel Carson', year_published: 1962 }
      resource = create(:resource, title: title, metadata: metadata)

      visit new_search_path
      within('.customer-search-form') do
        fill_in 'query', with: title
        click_button 'Go'
      end

      expect(page).to have_text(resource.title)
      expect(page).to have_text(resource.metadata[:author])
      expect(page).to have_text(resource.metadata[:year_published])
    end
  end
end
