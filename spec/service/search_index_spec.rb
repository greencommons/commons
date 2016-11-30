require 'rails_helper'

RSpec.describe SearchIndex do
  describe '.add' do
    it 'enqueues a job to include the record in the search index' do
      allow(IndexerJob).to receive(:perform_async)
      resource = build_stubbed(:resource)

      SearchIndex.add(resource)

      expect(IndexerJob).to have_received(:perform_async).
        with(:index, resource.class.name, resource.id)
    end

    context 'if index callbacks disabled', search_indexing_callbacks: false do
      it 'does not add to the search index' do
        allow(IndexerJob).to receive(:perform_async)
        resource = build_stubbed(:resource)

        SearchIndex.add(resource)

        expect(IndexerJob).not_to have_received(:perform_async).
          with(:index, resource.class.name, resource.id)
      end
    end
  end

  describe '.remove' do
    it 'removes the resource from the search index after deletion' do
      allow(IndexerJob).to receive(:perform_async)
      resource = build_stubbed(:resource)

      SearchIndex.remove(resource)

      expect(IndexerJob).to have_received(:perform_async).
        with(:delete, resource.class.name, resource.id)
    end

    context 'if index callbacks disabled', search_indexing_callbacks: false do
      it 'does not remove the resource from the index' do
        allow(IndexerJob).to receive(:perform_async)
        resource = build_stubbed(:resource)

        SearchIndex.remove(resource)

        expect(IndexerJob).not_to have_received(:perform_async).
          with(:delete, resource.class.name, resource.id)
      end
    end
  end

  describe '.search_index_callbacks_enabled?' do
    context 'if index callbacks disabled', search_indexing_callbacks: false do
      it 'is false' do
        allow(IndexerJob).to receive(:perform_async)
        allow(Rails.logger).to receive(:warn)

        expect(SearchIndex.search_index_callbacks_enabled?).to be_falsey
      end

      it 'logs a warning' do
        allow(IndexerJob).to receive(:perform_async)
        resource = build_stubbed(:resource)
        allow(Rails.logger).to receive(:warn)

        SearchIndex.remove(resource)

        expect(Rails.logger).to have_received(:warn).with(/callbacks.+disabled/)
      end
    end
  end
end
