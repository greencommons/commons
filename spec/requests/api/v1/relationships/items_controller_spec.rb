require 'rails_helper'

RSpec.describe Api::V1::Relationships::ItemsController, type: :request do
  let(:list) { create(:list) }
  let(:resource) { create(:resource) }
  let(:groups) { create_list(:group, 3) }
  let(:resources) { create_list(:resource, 3) }

  let(:user) { create(:user) }
  let(:api_key) { user.api_keys.create! }
  let(:headers) do
    {
      'Content-Type' => 'application/vnd.api+json',
      'Accept' => 'application/vnd.api+json',
      'Authorization' => "GC #{api_key.access_key}:#{api_key.secret_key}"
    }
  end

  describe 'GET /api/v1/lists/:id/relationships/items' do
    before do
      (groups + resources).each do |item|
        create(:lists_item, list: list, item: item)
      end
      get "/api/v1/lists/#{list.id}/relationships/items"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns the items as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data'].length).to eq(6)
    end
  end

  describe 'POST /api/v1/lists/:id/relationships/items' do
    context 'when authenticated' do
      context 'when list owner' do
        before do
          list.owner = user
          list.save
          post "/api/v1/lists/#{list.id}/relationships/items", params: {
            data: [
              { id: groups.first.id, type: 'groups' },
              { id: resources.first.id, type: 'resources' }
            ]
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the items as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data'].length).to eq(2)
        end

        it 'adds the items to the list' do
          expect(list.reload.lists_items.length).to eq 2
        end
      end

      context 'when not the list owner' do
        before do
          post "/api/v1/lists/#{list.id}/relationships/items", params: {
            data: [
              { id: groups.first.id, type: 'groups' },
              { id: resources.first.id, type: 'resources' }
            ]
          }.to_json, headers: headers
        end

        it 'returns 403 Forbidden' do
          expect(response.status).to eq 403
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'does not add the items to the list' do
          expect(list.reload.lists_items.length).to eq 0
        end
      end
    end

    context 'when unauthenticated' do
      before do
        post "/api/v1/lists/#{list.id}/relationships/items", params: {
          data: [
            { id: groups.first.id, type: 'groups' },
            { id: resources.first.id, type: 'resources' }
          ]
        }.to_json
      end

      it 'returns 401 Unauthorized' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH /api/v1/lists/:id/relationships/items' do
    before do
      patch "/api/v1/lists/#{list.id}/relationships/items", params: {
        data: [
          { id: groups.first.id, type: 'groups' },
          { id: resources.first.id, type: 'resources' }
        ]
      }.to_json, headers: headers
    end

    it 'returns 403 Forbidden' do
      expect(response.status).to eq 403
      expect(response.content_type).to eq 'application/vnd.api+json'
      expect(json_body['errors'][0]['detail']).to eq(
        'Complete replacement is not allowed for this resource.'
      )
    end
  end

  describe 'DELETE /api/v1/lists/:id/relationships/items' do
    context 'when authenticated' do
      context 'when the list owner is the current user' do
        before do
          (groups + resources).each do |item|
            create(:lists_item, list: list, item: item)
          end
          list.owner = user
          list.save
          delete "/api/v1/lists/#{list.id}/relationships/items", params: {
            data: [
              { id: groups.first.id, type: 'groups' },
              { id: resources.first.id, type: 'resources' }
            ]
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the items as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data'].length).to eq(4)
        end

        it 'removes the two items from the list' do
          expect(list.reload.lists_items.length).to eq 4
          expect(list.reload.lists_items.pluck(:id)).not_to include(groups.first.id)
          expect(list.reload.lists_items.pluck(:id)).not_to include(resources.first.id)
        end
      end

      context 'when the list is owned by someone else' do
        before do
          (groups + resources).each do |item|
            create(:lists_item, list: list, item: item)
          end

          delete "/api/v1/lists/#{list.id}/relationships/items", params: {
            data: [
              { id: groups.first.id, type: 'items' },
              { id: resources.last.id, type: 'items' }
            ]
          }.to_json, headers: headers
        end

        it 'returns 403 Forbidden' do
          expect(response.status).to eq 403
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'does not remove the items from the list' do
          expect(list.reload.lists_items.length).to eq 6
        end
      end
    end

    context 'when unauthenticated' do
      before do
        delete "/api/v1/lists/#{list.id}/relationships/items", params: {
          data: [
            { id: groups.first.id, type: 'items' },
            { id: resources.first.id, type: 'items' }
          ]
        }.to_json
      end

      it 'returns 401 Unauthorized' do
        expect(response.status).to eq 401
      end
    end
  end
end
