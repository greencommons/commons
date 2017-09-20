require 'rails_helper'

RSpec.describe S3SignaturesController, type: :request do
  describe 'GET /s3_signature' do
    def do_request(params)
      get s3_signature_path, params: params
    end

    let(:params) { { filename: filename } }
    let(:filename) { 'test.pdf' }
    let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

    before { do_request(params) }

    it 'succeeds' do
      expect(response).to be_success
    end

    it 'responds with the signature' do
      expect(json_response[:s3_signature][:acl]).to eq('public-read')
      expect(json_response[:s3_signature][:mime_type]).to eq('application/pdf')
      expect(json_response[:s3_signature][:key]).to match(/resources/)
      expect(json_response[:s3_signature][:key]).to match(/test.pdf/)
      expect(json_response[:s3_signature][:policy]).to be_present
      expect(json_response[:s3_signature][:signature]).to be_present
    end
  end
end
