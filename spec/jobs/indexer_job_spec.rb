require 'rails_helper'

RSpec.describe IndexerJob, :worker do
  describe '.perform', search_indexing_callbacks: false do
    it 'adds a new record to the search index' do
      travel_to(Time.zone.now) do
        record = create(:resource)
        allow(Elasticsearch::Model.client).to receive(:index)

        IndexerJob.perform_async(:index, record.class, record.id)

        expect(Elasticsearch::Model.client).to have_received(:index).
          with(
            index: 'resources',
            type: 'resource',
            id: record.id,
            body: record.__elasticsearch__.as_indexed_json,
          )
      end
    end

    it 'removes an existing record in the search index' do
      record = create(:resource)
      allow(Elasticsearch::Model.client).to receive(:delete)

      IndexerJob.perform_async(:delete, record.class, record.id)

      expect(Elasticsearch::Model.client).to have_received(:delete).
        with(
          index: 'resources',
          type: 'resource',
          id: record.id,
        )
    end
  end
end
