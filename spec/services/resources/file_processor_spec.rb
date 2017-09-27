require 'rails_helper'

RSpec.describe Resources::FileProcessor do
  let(:resource) do
    create(:resource,
           content_download_link: content_download_link,
           long_content: '')
  end
  let(:content_download_link) { 'https://uploads-commons-dev.s3.amazonaws.com/test.pdf' }

  describe '#call' do
    let(:call) { Resources::FileProcessor.new(resource).call }

    it 'updates the long_content' do
      call
      expect(resource.reload.long_content).not_to be_empty
    end
  end
end
