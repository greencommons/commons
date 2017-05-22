module Indexable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    index_name SearchIndex.index_name(self)
    attr_accessor :relevancy

    def run_if_public
      if respond_to?(:priv?) && priv?
        if previous_changes.keys.include?('privacy')
          RemoveFromIndexJob.perform_async(self.class.name, id)
        end
      else
        yield
      end
    end

    after_create :set_published_at

    after_commit on: [:create] do
      run_if_public { AddToIndexJob.perform_async(self.class.name, id) }
    end

    after_commit on: [:update] do
      run_if_public do
        changes = previous_changes.dup
        changes['tags'] =  changes.delete('cached_tags') if changes['cached_tags']
        UpdateIndexJob.perform_async(self.class.name, id, changes.keys)
      end
    end

    after_commit on: [:destroy] do
      run_if_public { RemoveFromIndexJob.perform_async(self.class.name, id) }
    end

    def set_published_at
      unless published_at
        if defined?(metadata) && metadata && metadata['date']
          begin
            self.published_at = Date.parse(metadata['date'])
          rescue ArgumentError
            self.published_at = created_at
          end
        else
          self.published_at = created_at
        end

        save!
      end
    end
  end
end
