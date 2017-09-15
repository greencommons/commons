require 'rails_helper'

RSpec.describe S3, type: :service do
<<<<<<< HEAD
  let(:s3) { S3.new }
=======
  let(:resource) { S3.new }
>>>>>>> Issue #212 - Implement S3 signatures for S3 direct upload functionality

  describe '#signed_url' do
    let(:path) { 'test.pdf' }
    let(:signed_param) { 'X-Amz-Signature' }
    it 'returns a signed url' do
<<<<<<< HEAD
      expect(s3.signed_url(path)).to be_include(signed_param)
=======
      expect(resource.signed_url(path)).to be_include(signed_param)
>>>>>>> Issue #212 - Implement S3 signatures for S3 direct upload functionality
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
<<<<<<< HEAD
      result = s3.generate_signature(path)
=======
      result = resource.generate_signature(path)
>>>>>>> Issue #212 - Implement S3 signatures for S3 direct upload functionality
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

<<<<<<< HEAD
      it { expect(s3.file_exists?(path)).to eq(true) }
=======
      it { expect(resource.file_exists?(path)).to eq(true) }
>>>>>>> Issue #212 - Implement S3 signatures for S3 direct upload functionality
    end

    context 'when file does not exists' do
      let(:path) { 'inexistent.pdf' }

<<<<<<< HEAD
      it { expect(s3.file_exists?(path)).to eq(false) }
=======
      it { expect(resource.file_exists?(path)).to eq(false) }
>>>>>>> Issue #212 - Implement S3 signatures for S3 direct upload functionality
    end
  end
end
