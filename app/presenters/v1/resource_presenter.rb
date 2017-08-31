module V1
  class ResourcePresenter < Yumi::Base
    type 'resource'
    attributes :title, :short_content, :resource_url, :published_at, :private, :tags,
               :resource_type, :created_at, :updated_at, :metadata
    links :self

    has_many :lists
    belongs_to :user

    def resource_url
      object.url
    end

    def private
      object.privacy == 'priv'
    end

    def excerpt
      object.excerpt
    end

    def tags
      object.cached_tags
    end
  end
end

