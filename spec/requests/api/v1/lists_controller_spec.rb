require 'rails_helper'

RSpec.describe Api::V1::ListsController, type: :request do
  let(:user) { create(:user) }
  let(:api_key) { user.api_keys.create! }
  let(:headers) do
    {
      'Content-Type' => 'application/vnd.api+json',
      'Accept' => 'application/vnd.api+json',
      'Authorization' => "GC #{api_key.access_key}:#{api_key.secret_key}"
    }
  end

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
      expect(json_body['data']['id']).to eq list.id.to_s
    end
  end

  describe 'POST /api/v1/lists' do
    context 'authenticated' do
      context 'with valid params' do
        before do
          post '/api/v1/lists', params: {
            data: {
              type: 'lists',
              attributes: {
                name: 'My Awesome List'
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the group as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data']['id']).to eq List.last.id.to_s
        end

        it 'creates the group' do
          expect(List.count).to eq 1
        end
      end

      context 'with invalid params' do
        before do
          post '/api/v1/lists', params: {
            data: {
              type: 'lists',
              attributes: {
                name: nil
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 400 OK' do
          expect(response.status).to eq 400
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'creates the group' do
          expect(List.count).to eq 0
        end
      end
    end

    context 'unauthenticated' do
      before do
        post '/api/v1/lists', params: {
          data: {
            type: 'lists',
            attributes: {
              name: 'My Awesome List'
            }
          }
        }.to_json, headers: {
          'Authorization' => 'GC 123:123'
        }
      end

      it 'returns 401 OK' do
        expect(response.status).to eq 401
      end
    end
  end
end
