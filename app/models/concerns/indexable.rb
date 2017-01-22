module Indexable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    index_name SearchIndex.index_name(self)

    after_create do
      AddToIndexJob.perform_async(self.class.name, id)
    end

    after_update do
      UpdateIndexJob.perform_async(self.class.name, id, changed)
    end

    after_destroy do
      RemoveFromIndexJob.perform_async(self.class.name, id)
    end
  end
end
