class AddResourceTypeIndexToResource < ActiveRecord::Migration[5.0]
  def change
    change_table :resources do |t|
      t.index :resource_type
    end
  end
end
