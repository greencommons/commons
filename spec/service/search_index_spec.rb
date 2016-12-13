require 'rails_helper'

RSpec.describe SearchIndex do
  describe '#add' do
    it 'adds the record to the search index' do
      travel_to(Time.zone.now) do
        allow(Elasticsearch::Model.client).to receive(:index)
        record = create(:resource)
        model_name = record.class.name

        SearchIndex.new(model_name: model_name, id: record.id).add

        expect(Elasticsearch::Model.client).to have_received(:index).
          with(
            index: model_name.constantize.index_name,
            type: model_name.downcase,
            id: record.id,
            body: record.__elasticsearch__.as_indexed_json,
          )
      end
    end

    context 'when asked to be performed asynchronously' do
      it 'enqueues a job to include the record in the search index' do
        allow(AddToIndexJob).to receive(:perform_async)
        record = build_stubbed(:resource)
        model_name = record.class.name

        SearchIndex.new(model_name: model_name, id: record.id, async: true).add

        expect(AddToIndexJob).to have_received(:perform_async).
          with(record.class.name, record.id)
      end

      context 'if index callbacks disabled', search_indexing_callbacks: false do
        it 'does not add to the search index' do
          allow(AddToIndexJob).to receive(:perform_async)
          record = build_stubbed(:resource)
          model_name = record.class.name

          SearchIndex.new(model_name: model_name, id: record.id, async: true).add

          expect(AddToIndexJob).not_to have_received(:perform_async).
            with(record.class.name, record.id)
        end

        it 'logs a warning' do
          record = create(:resource)
          allow(Rails.logger).to receive(:warn)

          SearchIndex.new(
            model_name: record.class.name,
            id: record.id,
            async: true,
          ).add

          expect(Rails.logger).to have_received(:warn).with(/callbacks.+disabled/)
        end
      end
    end
  end

  describe '#remove' do
    it 'removes the record from the index' do
      record = create(:resource)
      model_name = record.class.name
      allow(Elasticsearch::Model.client).to receive(:delete)

      SearchIndex.new(model_name: model_name, id: record.id).remove

      expect(Elasticsearch::Model.client).to have_received(:delete).
        with(
          index: model_name.constantize.index_name,
          type: model_name.downcase,
          id: record.id,
        )
    end

    context 'when asked to be performed asynchronously' do
      it 'removes the resource from the search index after deletion' do
        allow(RemoveFromIndexJob).to receive(:perform_async)
        record = build_stubbed(:resource)

        SearchIndex.new(
          model_name: record.class.name,
          id: record.id,
          async: true,
        ).remove

        expect(RemoveFromIndexJob).to have_received(:perform_async).
          with(record.class.name, record.id)
      end

      context 'if index callbacks disabled', search_indexing_callbacks: false do
        it 'does not remove the resource from the index' do
          allow(RemoveFromIndexJob).to receive(:perform_async)
          record = build_stubbed(:resource)

          SearchIndex.new(
            model_name: record.class.name,
            id: record.id,
            async: true,
          ).remove

          expect(RemoveFromIndexJob).not_to have_received(:perform_async).
            with(record.class.name, record.id)
        end
      end
    end
  end
end
