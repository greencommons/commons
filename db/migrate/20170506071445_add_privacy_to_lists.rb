class AddPrivacyToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :privacy, :integer, default: 1, null: false
  end
end
