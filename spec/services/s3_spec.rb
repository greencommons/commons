require 'rails_helper'

RSpec.describe S3, type: :service do
  let(:s3) { S3.new }

  describe '#signed_url' do
    let(:path) { 'test.pdf' }
    let(:signed_param) { 'X-Amz-Signature' }
    it 'returns a signed url' do
      expect(s3.signed_url(path)).to be_include(signed_param)
    end
  end

  describe '#generate_signature' do
    let(:path) { 'test.pdf' }
    let(:signature) do
      {
        acl: 'public-read',
        key: 'test.pdf',
        mime_type: 'application/pdf'
      }
    end

    it 'returns the signature for direct upload' do
      result = s3.generate_signature(path)
      expect(result[:acl]).to eq(signature[:acl])
      expect(result[:key]).to eq(signature[:key])
      expect(result[:mime_type]).to eq(signature[:mime_type])
      expect(result[:policy]).to be_present
      expect(result[:signature]).to be_present
    end
  end

  describe '#file_exists?' do
    context 'when file exists' do
      let(:path) { 'test.pdf' }

      it { expect(s3.file_exists?(path)).to eq(true) }
    end

    context 'when file does not exists' do
      let(:path) { 'inexistent.pdf' }

      it { expect(s3.file_exists?(path)).to eq(false) }
    end
  end
end
