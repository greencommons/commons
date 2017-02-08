class AddCachedTagsToLists < ActiveRecord::Migration[5.0]
  def up
    add_column :lists, :cached_tags, :text, array: true, default: []
  end

  def down
    remove_column :lists, :cached_tags
  end
end
