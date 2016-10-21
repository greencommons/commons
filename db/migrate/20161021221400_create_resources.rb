class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.string      :title, null: false
      t.belongs_to  :user, null: false
      t.json        :metadata
      t.timestamps
    end
  end
end
