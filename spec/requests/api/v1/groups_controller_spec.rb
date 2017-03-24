require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :request do
  describe 'GET /api/v1/groups/:id' do
    let(:group) { create(:group) }

    before do
      get "/api/v1/groups/#{group.id}"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
    end

    it 'returns the group as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(JSON.parse(response.body)['data']['id']).to eq "#{group.id}"
    end
  end
end
