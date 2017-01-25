require 'rails_helper'

RSpec.describe 'Resources', type: :request do
  let(:resource) { create(:resource) }

  describe 'GET /resources/:id' do
    it 'gets 200' do
      get resource_path(resource)
      expect(response).to have_http_status(200)
    end
  end
end
