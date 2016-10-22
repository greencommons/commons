class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.string      :title, null: false
      t.integer     :resource_type, default: 0, null: false
      t.belongs_to  :user
      t.json        :metadata
      t.timestamps
    end
  end
end
