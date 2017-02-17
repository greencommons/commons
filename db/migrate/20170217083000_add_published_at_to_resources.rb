class AddPublishedAtToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :published_at, :timestamp
  end
end
