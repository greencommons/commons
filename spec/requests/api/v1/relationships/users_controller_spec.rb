require 'rails_helper'

RSpec.describe Api::V1::Relationships::UsersController, type: :request do
  let(:group) { create(:group) }
  let(:users) { create_list(:user, 5) }

  let(:user) { create(:user) }
  let(:api_key) { user.api_keys.create! }
  let(:headers) do
    {
      'Content-Type' => 'application/vnd.api+json',
      'Accept' => 'application/vnd.api+json',
      'Authorization' => "GC #{api_key.access_key}:#{api_key.secret_key}"
    }
  end

  describe 'GET /api/v1/groups/:id/relationships/users' do
    before do
      users.each { |u| group.add_user(u) }
      get "/api/v1/groups/#{group.id}/relationships/users"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns the users as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data'].length).to eq(5)
    end
  end

  describe 'POST /api/v1/groups/:id/relationships/users' do
    context 'when authenticated' do
      context 'when group admin' do
        before do
          group.add_admin(user)
          post "/api/v1/groups/#{group.id}/relationships/users", params: {
            data: [
              { id: users.first.id, type: 'users' },
              { id: users.last.id, type: 'users' }
            ]
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the users as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data'].length).to eq(3)
        end

        it 'adds the users to the group' do
          expect(group.users.length).to eq 3
        end
      end

      context 'when not a group admin' do
        before do
          post "/api/v1/groups/#{group.id}/relationships/users", params: {
            data: [
              { id: users.first.id, type: 'users' },
              { id: users.last.id, type: 'users' }
            ]
          }.to_json, headers: headers
        end

        it 'returns 403 Forbidden' do
          expect(response.status).to eq 403
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'does not add the users to the group' do
          expect(group.users.length).to eq 0
        end
      end
    end

    context 'when unauthenticated' do
      before do
        post "/api/v1/groups/#{group.id}/relationships/users", params: {
          data: [
            { id: users.first.id, type: 'users' },
            { id: users.last.id, type: 'users' }
          ]
        }.to_json
      end

      it 'returns 401 Unauthorized' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH /api/v1/groups/:id/relationships/users' do
    before do
      patch "/api/v1/groups/#{group.id}/relationships/users", params: {
        data: [
          { id: users.first.id, type: 'users' },
          { id: users.last.id, type: 'users' }
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

  describe 'DELETE /api/v1/groups/:id/relationships/users' do
    context 'when authenticated' do
      context 'when group admin' do
        before do
          group.add_admin(user)
          users.each { |u| group.add_user(u) }

          delete "/api/v1/groups/#{group.id}/relationships/users", params: {
            data: [
              { id: users.first.id, type: 'users' },
              { id: users.last.id, type: 'users' }
            ]
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the users as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data'].length).to eq(4)
        end

        it 'removes the two users from the group' do
          expect(group.users.length).to eq 4
          expect(group.users.pluck(:id)).not_to include(users.first.id)
          expect(group.users.pluck(:id)).not_to include(users.last.id)
        end
      end

      context 'when not a group admin' do
        before do
          users.each { |u| group.add_user(u) }

          delete "/api/v1/groups/#{group.id}/relationships/users", params: {
            data: [
              { id: users.first.id, type: 'users' },
              { id: users.last.id, type: 'users' }
            ]
          }.to_json, headers: headers
        end

        it 'returns 403 Forbidden' do
          expect(response.status).to eq 403
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'does not remove the users from the group' do
          expect(group.users.length).to eq 5
        end
      end
    end

    context 'when unauthenticated' do
      before do
        delete "/api/v1/groups/#{group.id}/relationships/users", params: {
          data: [
            { id: users.first.id, type: 'users' },
            { id: users.last.id, type: 'users' }
          ]
        }.to_json
      end

      it 'returns 401 Unauthorized' do
        expect(response.status).to eq 401
      end
    end
  end
end
