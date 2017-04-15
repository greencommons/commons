require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :request do
  describe 'GET /api/v1/search' do
    let(:title) { Faker::Hipster.sentence }

    before do
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

    describe 'pagination' do
      it 'returns the links structure', :worker, :elasticsearch do
        get "/api/v1/search?q=#{title}&page=2&per=1"

        expect(response).to match_response_schema('jsonapi')
        expect(json_body['links']).to eq(
          'first' => "http://www.example.com/api/v1/search?q=#{title}&page=1&per=1",
          'last' => "http://www.example.com/api/v1/search?q=#{title}&page=3&per=1",
          'next' => "http://www.example.com/api/v1/search?q=#{title}&page=3&per=1",
          'prev' => "http://www.example.com/api/v1/search?q=#{title}&page=1&per=1",
          'self' => "http://www.example.com/api/v1/search?q=#{title}&page=2&per=1"
        )
      end
    end
  end
end
