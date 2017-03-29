require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :request do
  describe 'GET /api/v1/search' do
    let(:title) { Faker::Hipster.sentence }

    before do
      title = Faker::Hipster.sentence

      create(:resource, title: "#{title} My Resource")
      create(:group, name: "#{title} My Group")
      create(:list, name: "#{title} My List")

      wait_for do
        Elasticsearch::Model.search(title, [Resource, Group, List]).results.total
      end.to eq(3)

      get "/api/v1/search?q=#{title}"
    end

    it 'returns the search results as JSON API', :worker, :elasticsearch do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data'].length).to eq 3
    end
  end
end
