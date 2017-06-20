require 'rails_helper'

RSpec.describe Api::V1::NetworksController, type: :request do
  let(:user) { create(:user) }
  let(:api_key) { user.api_keys.create! }
  let(:headers) do
    {
      'Content-Type' => 'application/vnd.api+json',
      'Accept' => 'application/vnd.api+json',
      'Authorization' => "GC #{api_key.access_key}:#{api_key.secret_key}"
    }
  end

  describe 'GET /api/v1/networks', :worker, :elasticsearch do
    before do
      create_list(:network, 5, name: 'Super Network')
      wait_for { Network.search('Super Network').results.total }.to eq(5)
      get '/api/v1/networks'
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns the networks as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data'].length).to eq(5)
    end
  end

  describe 'GET /api/v1/networks/:id' do
    let(:network) { create(:network) }

    before do
      get "/api/v1/networks/#{network.id}"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns the network as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data']['id']).to eq network.id.to_s
    end
  end

  describe 'POST /api/v1/networks' do
    context 'authenticated' do
      context 'with invalid content type' do
        it 'returns 400 OK' do
          post '/api/v1/networks', params: '{"test":"a"}', headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/vnd.api+json',
            'Authorization' => "GC #{api_key.access_key}:#{api_key.secret_key}"
          }

          expect(response.status).to eq 415
          expect(response.content_type).to eq 'application/vnd.api+json'
        end
      end

      context 'with invalid json' do
        it 'returns 400 OK' do
          post '/api/v1/networks', params: '{"test":"a"', headers: headers

          expect(response.status).to eq 400
          expect(response.content_type).to eq 'application/vnd.api+json'
        end
      end

      context 'with empty params' do
        it 'returns 400 OK' do
          post '/api/v1/networks', params: '{}', headers: headers

          expect(response.status).to eq 400
          expect(response.content_type).to eq 'application/vnd.api+json'
        end
      end

      context 'with empty data params' do
        it 'returns 400 OK' do
          post '/api/v1/networks', params: '{"data": {}}', headers: headers

          expect(response.status).to eq 400
          expect(response.content_type).to eq 'application/vnd.api+json'
        end
      end

      context 'with valid params' do
        before do
          post '/api/v1/networks', params: {
            data: {
              type: 'networks',
              attributes: {
                name: 'My Awesome Network'
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the network as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data']['id']).to eq Network.last.id.to_s
        end

        it 'creates the network' do
          expect(Network.count).to eq 1
        end
      end

      context 'with invalid params' do
        before do
          post '/api/v1/networks', params: {
            data: {
              type: 'networks',
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

        it 'creates the network' do
          expect(Network.count).to eq 0
        end
      end
    end

    context 'unauthenticated' do
      before do
        post '/api/v1/networks', params: {
          data: {
            type: 'networks',
            attributes: {
              name: 'My Awesome Network'
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

  describe 'PATCH /api/v1/networks/:id' do
    context 'authenticated' do
      context 'with valid params' do
        before do
          network = create(:network)
          network.add_admin(user)

          patch "/api/v1/networks/#{network.id}", params: {
            data: {
              type: 'networks',
              attributes: {
                name: 'My Updated Awesome Network'
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the network as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data']['id']).to eq Network.last.id.to_s
          expect(json_body['data']['attributes']['name']).to eq 'My Updated Awesome Network'
        end

        it 'updates the network' do
          expect(Network.last.name).to eq 'My Updated Awesome Network'
        end
      end

      context 'with invalid params' do
        before do
          network = create(:network, name: 'Super Network')
          network.add_admin(user)

          patch "/api/v1/networks/#{network.id}", params: {
            data: {
              type: 'networks',
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

        it 'does not update the network' do
          expect(Network.last.name).to eq 'Super Network'
        end
      end
    end

    context 'unauthenticated' do
      before do
        network = create(:network)
        patch "/api/v1/networks/#{network.id}", params: {
          data: {
            type: 'networks',
            attributes: {
              name: 'My Awesome Network'
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
