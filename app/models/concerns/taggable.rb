# frozen_string_literal: true
module Taggable
  extend ActiveSupport::Concern

  included do
    acts_as_taggable

    after_touch do
      update(cached_tags: tag_list)
    end
  end

  def as_indexed_json(_options = {})
    json = as_json
    json["tags"] = json.delete("cached_tags")
    json
  end
end
