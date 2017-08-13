module V1
  class NetworkPresenter < Yumi::Base
    type 'network'
    attributes :name, :short_description, :long_description, :relevancy, :tags,
               :published_at, :members_count, :lists_count, :resources_count,
               :created_at, :updated_at
    links :self
    has_many :users

    def tags
      object.cached_tags
    end

    def members_count
      object.users.count
    end

    def lists_count
      object.lists_items_count
    end

    def resources_count
      object.resources.count
    end
  end
end
