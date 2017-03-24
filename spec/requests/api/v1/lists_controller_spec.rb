require 'rails_helper'

RSpec.describe Api::V1::ListsController, type: :request do
  describe 'GET /api/v1/lists/:id' do
    let(:list) { create(:list) }

    before do
      get "/api/v1/lists/#{list.id}"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns the list as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data']['id']).to eq "#{list.id}"
    end
  end
end
