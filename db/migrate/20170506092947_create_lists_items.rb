class CreateListsItems < ActiveRecord::Migration[5.0]
  def change
    create_table :lists_items do |t|
      t.belongs_to :list, index: true
      t.belongs_to :item, polymorphic: true, index: true
      t.text :note
    end

    add_index :lists_items, [:list_id, :item_id, :item_type], unique: true
  end
end
