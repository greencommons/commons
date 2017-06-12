require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:user) { create(:user, email: 'pat@example.com') }
  let(:api_key) { user.api_keys.create! }
  let(:headers) do
    {
      'Content-Type' => 'application/vnd.api+json',
      'Accept' => 'application/vnd.api+json',
      'Authorization' => "GC #{api_key.access_key}:#{api_key.secret_key}"
    }
  end

  describe 'POST /api/v1/users' do
    context 'authenticated' do
      context 'with valid params' do
        before do
          post '/api/v1/users', params: {
            data: {
              type: 'users',
              attributes: {
                email: 'john@example.com',
                first_name: 'John',
                last_name: 'Doe',
                password: 'password',
                password_confirmation: 'password'
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the user as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data']['id']).to eq User.last.id.to_s
        end

        it 'creates the user' do
          expect(User.count).to eq 2
        end
      end

      context 'with invalid params' do
        before do
          post '/api/v1/users', params: {
            data: {
              type: 'users',
              attributes: {
                email: nil
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 400 OK' do
          expect(response.status).to eq 400
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'creates the user' do
          expect(User.count).to eq 1
        end
      end
    end

    context 'unauthenticated' do
      before do
        post '/api/v1/users', params: {
          data: {
            type: 'users',
            attributes: {
              email: 'john@example.com',
              first_name: 'John',
              last_name: 'Doe',
              password: 'password',
              password_confirmation: 'password'
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

  describe 'PATCH /api/v1/users/:id' do
    context 'authenticated' do
      context 'with valid params' do
        before do
          patch "/api/v1/users/#{user.id}", params: {
            data: {
              type: 'users',
              attributes: {
                first_name: 'Alice'
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the user as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data']['id']).to eq User.last.id.to_s
          expect(json_body['data']['attributes']['first_name']).to eq 'Alice'
        end

        it 'updates the user' do
          expect(User.last.first_name).to eq 'Alice'
        end
      end

      context 'with invalid params' do
        before do
          patch "/api/v1/users/#{user.id}", params: {
            data: {
              type: 'users',
              attributes: {
                email: nil
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 400 OK' do
          expect(response.status).to eq 400
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'does not update the user' do
          expect(User.last.email).to eq 'pat@example.com'
        end
      end
    end

    context 'unauthenticated' do
      before do
        patch "/api/v1/users/#{user.id}", params: {
          data: {
            type: 'users',
            attributes: {
              first_name: 'Alice'
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
