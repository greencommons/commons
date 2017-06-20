require 'rails_helper'

RSpec.feature 'Interacting with resources', :worker, :elasticsearch do
  scenario 'users can see a list of related records' do
    feature_login

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

    visit resource_path(resource)

    expect(page).to have_content('My Resource')
    expect(page).to have_content('Explore')
    expect(page).to have_content('Protection Network')
    expect(page).to have_content('Helpful List')
    expect(page).not_to have_content('Help Network')
  end
end
