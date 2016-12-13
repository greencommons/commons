require 'rails_helper'

RSpec.describe RemoveFromIndexJob, :worker do
  describe '.perform', search_indexing_callbacks: false do
    it 'removes an existing record in the search index' do
      record = create(:resource)
      model_name = record.class.name
      index = double('SearchIndex', remove: true)
      allow(SearchIndex).to receive(:new).and_return(index)

      RemoveFromIndexJob.perform_async(record.class, record.id)

      expect(SearchIndex).to have_received(:new).
        with(model_name: model_name, id: record.id)
      expect(index).to have_received(:remove)
    end
  end
end
