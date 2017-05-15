class AddPublishedAtToListItem < ActiveRecord::Migration[5.0]
  def change
    add_column :lists_items, :published_at, :timestamp
  end
end
