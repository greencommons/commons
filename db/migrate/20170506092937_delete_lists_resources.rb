class DeleteListsResources < ActiveRecord::Migration[5.0]
  def up
    drop_table :lists_resources
  end

  def down
    create_table :lists_resources, id: false do |t|
      t.belongs_to  :list
      t.belongs_to  :resource
    end
  end
end
