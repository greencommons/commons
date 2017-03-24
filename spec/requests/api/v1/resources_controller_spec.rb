require 'rails_helper'

RSpec.describe Api::V1::ResourcesController, type: :request do
  describe 'GET /api/v1/resources/:id' do
    let(:resource) { create(:resource) }

    before do
      get "/api/v1/resources/#{resource.id}"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns the resource as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data']['id']).to eq "#{resource.id}"
    end
  end
end
