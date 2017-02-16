module Indexable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    index_name SearchIndex.index_name(self)

    def run_if_public(&block)
      return if self.respond_to?(:priv?) && self.priv?
      block.call
    end

    after_commit on: [:create] do
      run_if_public { AddToIndexJob.perform_async(self.class.name, id) }
    end

    after_commit on: [:update] do
      run_if_public do
        changes = previous_changes.dup
        changes['tags'] =  changes.delete('cached_tags')
        UpdateIndexJob.perform_async(self.class.name, id, changes.keys)
      end
    end

    after_commit on: [:destroy] do
      run_if_public { RemoveFromIndexJob.perform_async(self.class.name, id) }
    end
  end
end
