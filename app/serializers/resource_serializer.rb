class ResourceSerializer < ApplicationSerializer
  attributes :id, :title, :excerpt, :published_at, :tags, :resource_type

  def excerpt
    object.excerpt
  end

  def tags
    object.cached_tags
  end
end
