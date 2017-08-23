class AddListsCountToNetworksAndResources < ActiveRecord::Migration[5.0]
  def change
    add_column :networks, :lists_items_count, :integer, default: 0
    add_column :resources, :lists_items_count, :integer, default: 0
  end
end
