class RemoveContentFromResources < ActiveRecord::Migration[5.0]
  def change
    remove_column :resources, :content, :text
  end
end
