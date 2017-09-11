require 'rails_helper'

RSpec.feature 'User visits home page' do
  scenario 'can go to the search page for a specific resource' do
    visit('/')
    all('a.resource-details__see-more')[0].click
    expect(find('#filters_model_types_resources')['checked']).to eq(true)
    expect(find('#filters_resource_types_books')['checked']).to eq(true)

    expect(find('#filters_model_types_lists')['checked']).to eq(false)
    expect(find('#filters_model_types_networks')['checked']).to eq(false)
    %w(article report audio url image profile course dataset syllabus video).
      each do |resource_type|
      expect(find("#filters_resource_types_#{resource_type.pluralize}")['checked']).to eq(false)
    end
  end
end
