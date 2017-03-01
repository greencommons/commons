module V1
  class GroupSerializer < ApplicationSerializer
    attributes :id, :name, :short_description, :long_description, :tags,
               :published_at, :members_count, :lists_count, :resources_count

    def tags
      object.cached_tags
    end

    def members_count
      object.users.count
    end

    def lists_count
      object.lists.count
    end

    def resources_count
      object.resources.count
    end
  end
end
