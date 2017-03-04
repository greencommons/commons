# frozen_string_literal: true
class AddCachedTagListToResources < ActiveRecord::Migration[5.0]
  def up
    add_column :resources, :cached_tags, :text, array: true, default: []
  end

  def down
    remove_column :resources, :cached_tags
  end
end
