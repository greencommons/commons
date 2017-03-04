# frozen_string_literal: true
class AddCachedTagListToGroups < ActiveRecord::Migration[5.0]
  def up
    add_column :groups, :cached_tags, :text, array: true, default: []
  end

  def down
    remove_column :groups, :cached_tags
  end
end
