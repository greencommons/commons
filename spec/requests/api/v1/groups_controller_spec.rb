require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :request do
  let(:user) { create(:user) }
  let(:api_key) { user.api_keys.create! }
  let(:headers) do
    {
      'Content-Type' => 'application/vnd.api+json',
      'Accept' => 'application/vnd.api+json',
      'Authorization' => "GC #{api_key.access_key}:#{api_key.secret_key}"
    }
  end

  describe 'GET /api/v1/groups', :worker, :elasticsearch do
    before do
      create_list(:group, 5, name: 'Super Group')
      wait_for { Group.search('Super Group').results.total }.to eq(5)
      get '/api/v1/groups'
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns the groups as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data'].length).to eq(5)
    end
  end

  describe 'GET /api/v1/groups/:id' do
    let(:group) { create(:group) }

    before do
      get "/api/v1/groups/#{group.id}"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns the group as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data']['id']).to eq group.id.to_s
    end
  end

  describe 'POST /api/v1/groups' do
    context 'authenticated' do
      context 'with valid params' do
        before do
          post '/api/v1/groups', params: {
            data: {
              type: 'groups',
              attributes: {
                name: 'My Awesome Group'
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
          expect(json_body['data']['id']).to eq Group.last.id.to_s
        end

        it 'creates the group' do
          expect(Group.count).to eq 1
        end
      end

      context 'with invalid params' do
        before do
          post '/api/v1/groups', params: {
            data: {
              type: 'groups',
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
          expect(Group.count).to eq 0
        end
      end
    end

    context 'unauthenticated' do
      before do
        post '/api/v1/groups', params: {
          data: {
            type: 'groups',
            attributes: {
              name: 'My Awesome Group'
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

  describe 'PATCH /api/v1/groups/:id' do
    context 'authenticated' do
      context 'with valid params' do
        before do
          group = create(:group)
          group.add_admin(user)

          patch "/api/v1/groups/#{group.id}", params: {
            data: {
              type: 'groups',
              attributes: {
                name: 'My Updated Awesome Group'
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
          expect(json_body['data']['id']).to eq Group.last.id.to_s
          expect(json_body['data']['attributes']['name']).to eq 'My Updated Awesome Group'
        end

        it 'updates the group' do
          expect(Group.last.name).to eq 'My Updated Awesome Group'
        end
      end

      context 'with invalid params' do
        before do
          group = create(:group, name: 'Super Group')
          group.add_admin(user)

          patch "/api/v1/groups/#{group.id}", params: {
            data: {
              type: 'groups',
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

        it 'does not update the group' do
          expect(Group.last.name).to eq 'Super Group'
        end
      end
    end

    context 'unauthenticated' do
      before do
        group = create(:group)
        patch "/api/v1/groups/#{group.id}", params: {
          data: {
            type: 'groups',
            attributes: {
              name: 'My Awesome Group'
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
