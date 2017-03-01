module V1
  class ListSerializer < ApplicationSerializer
    attributes :id, :name, :description, :published_at, :resources_count

    def resources_count
      object.resources.count
    end
  end
end
