class AddItemsCountToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :lists_items_count, :integer, default: 0
  end
end
