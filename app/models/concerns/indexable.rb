module Indexable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    index_name SearchIndex.index_name(self)

    after_commit on: [:create] do
      AddToIndexJob.perform_async(self.class.name, id)
    end

    after_commit on: [:update] do
      _changes = previous_changes.dup
      _changes['tags'] = _changes.delete('cached_tags')
      UpdateIndexJob.perform_async(self.class.name, id, _changes.keys)
    end

    after_commit on: [:destroy] do
      RemoveFromIndexJob.perform_async(self.class.name, id)
    end
  end
end
