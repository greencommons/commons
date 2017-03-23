module V1
  class ResourcePresenter < Yumi::Base
    type 'resource'
    attributes :id, :title, :excerpt, :published_at, :tags, :resource_type
    links :self

    has_many :lists
    belongs_to :user

    def excerpt
      object.excerpt
    end

    def tags
      object.cached_tags
    end
  end
end
