# frozen_string_literal: true
require "rails_helper"

RSpec.feature "Interacting with resources", :worker, :elasticsearch do
  scenario "users can see a list of related records" do
    feature_login

    resource = create(:resource, title: "My Resource")
    protection_group = create(:group, name: "Protection Group")
    help_group = create(:group, name: "Help Group")
    helpful_list = create(:list, name: "Helpful List")

    resource.tag_list.add("ocean")
    resource.tag_list.add("sky")
    resource.save!

    protection_group.tag_list.add("ocean")
    protection_group.save!

    help_group.tag_list.add("mountain")
    help_group.save!

    helpful_list.tag_list.add("sky")
    helpful_list.save!

    wait_for do
      Suggesters::Tags.new(tags: %w(ocean sky)).suggest.size
    end.to eq(3)

    visit resource_path(resource)

    expect(page).to have_content("My Resource")
    expect(page).to have_content("EXPLORE")
    expect(page).to have_content("Protection Group")
    expect(page).to have_content("Helpful List")
    expect(page).not_to have_content("Help Group")
  end
end
