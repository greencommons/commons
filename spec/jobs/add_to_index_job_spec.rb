require 'rails_helper'

RSpec.describe AddToIndexJob, :worker do
  describe '.perform', search_indexing_callbacks: false do
    it 'adds a new record to the search index' do
      travel_to(Time.zone.now) do
        record = create(:resource)
        model_name = record.class.name
        index = double('SearchIndex', add: true)
        allow(SearchIndex).to receive(:new).and_return(index)

        AddToIndexJob.perform_async(model_name, record.id)

        expect(SearchIndex).to have_received(:new).
          with(model_name: model_name, id: record.id)
        expect(index).to have_received(:add)
      end
    end
  end
end
