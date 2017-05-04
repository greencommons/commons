module Taggable
  extend ActiveSupport::Concern

  included do
    acts_as_taggable

    before_save do
      self.cached_tags = tag_list
    end

    after_touch do
      update(cached_tags: tag_list)
    end
  end

  def as_indexed_json(_options = {})
    json = as_json
    json['tags'] = json.delete('cached_tags')
    json
  end
end
