module V1
  class ResourcePresenter < Yumi::Base
    type 'resource'
    attributes :title, :short_content, :url, :published_at, :private, :tags,
               :resource_type, :created_at, :updated_at
    links :self

    has_many :lists
    belongs_to :user

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
