module Indexable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    index_name SearchIndex.index_name(self)

    after_commit on: [:create, :update] do
      AddToIndexJob.perform_async(self.class.name, id)
    end

    after_commit on: [:destroy] do
      RemoveFromIndexJob.perform_async(self.class.name, id)
    end
  end
end
