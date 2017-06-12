require 'rails_helper'

RSpec.describe Api::V1::ResourcesController, type: :request do
  let(:resource) { create(:resource) }
  let(:user) { create(:user) }
  let(:api_key) { user.api_keys.create! }
  let(:headers) do
    {
      'Content-Type' => 'application/vnd.api+json',
      'Accept' => 'application/vnd.api+json',
      'Authorization' => "GC #{api_key.access_key}:#{api_key.secret_key}"
    }
  end

  describe 'GET /api/v1/resources/:id' do
    before do
      get "/api/v1/resources/#{resource.id}"
    end

    it 'returns 200 OK' do
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns the resource as JSON API' do
      expect(response).to match_response_schema('jsonapi')
      expect(json_body['data']['id']).to eq resource.id.to_s
    end
  end

  describe 'POST /api/v1/resources' do
    context 'authenticated' do
      context 'with valid params' do
        before do
          post '/api/v1/resources', params: {
            data: {
              type: 'resources',
              attributes: {
                title: 'My Awesome Resource',
                url: 'http://example.com'
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 200 OK' do
          expect(response.status).to eq 200
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'returns the resource as JSON API' do
          expect(response).to match_response_schema('jsonapi')
          expect(json_body['data']['id']).to eq Resource.last.id.to_s
        end

        it 'creates the resource with the current user as owner' do
          expect(Resource.count).to eq 1
          expect(Resource.last.title).to eq 'My Awesome Resource'
        end
      end

      context 'with invalid params' do
        before do
          post '/api/v1/resources', params: {
            data: {
              type: 'resources',
              attributes: {
                title: nil
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 400 OK' do
          expect(response.status).to eq 400
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'creates the resource' do
          expect(Resource.count).to eq 0
        end
      end
    end

    context 'unauthenticated' do
      before do
        post '/api/v1/resources', params: {
          data: {
            type: 'resources',
            attributes: {
              title: 'My Awesome Resource'
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

  describe 'PATCH /api/v1/resources/:id' do
    context 'authenticated' do
      context 'when the user owns the resource' do
        context 'with valid params' do
          before do
            resource = create(:resource, user: user)

            patch "/api/v1/resources/#{resource.id}", params: {
              data: {
                type: 'resources',
                attributes: {
                  title: 'My Updated Awesome Resource'
                }
              }
            }.to_json, headers: headers
          end

          it 'returns 200 OK' do
            expect(response.status).to eq 200
            expect(response.content_type).to eq 'application/vnd.api+json'
          end

          it 'returns the resource as JSON API' do
            expect(response).to match_response_schema('jsonapi')
            expect(json_body['data']['id']).to eq Resource.last.id.to_s
            expect(json_body['data']['attributes']['title']).to eq 'My Updated Awesome Resource'
          end

          it 'updates the resource' do
            expect(Resource.last.title).to eq 'My Updated Awesome Resource'
          end
        end

        context 'with invalid params' do
          before do
            resource = create(:resource, user: user, title: 'Super Resource')

            patch "/api/v1/resources/#{resource.id}", params: {
              data: {
                type: 'resources',
                attributes: {
                  title: nil
                }
              }
            }.to_json, headers: headers
          end

          it 'returns 400 OK' do
            expect(response.status).to eq 400
            expect(response.content_type).to eq 'application/vnd.api+json'
          end

          it 'does not update the resource' do
            expect(Resource.last.title).to eq 'Super Resource'
          end
        end
      end

      context 'when the resource is owned by someone else' do
        before do
          resource = create(:resource, title: 'Super Resource')

          patch "/api/v1/resources/#{resource.id}", params: {
            data: {
              type: 'resources',
              attributes: {
                title: nil
              }
            }
          }.to_json, headers: headers
        end

        it 'returns 400 OK' do
          expect(response.status).to eq 403
          expect(response.content_type).to eq 'application/vnd.api+json'
        end

        it 'does not update the resource' do
          expect(Resource.last.title).to eq 'Super Resource'
        end
      end
    end

    context 'unauthenticated' do
      before do
        resource = create(:resource)
        patch "/api/v1/resources/#{resource.id}", params: {
          data: {
            type: 'resources',
            attributes: {
              title: 'My Awesome Resource'
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
