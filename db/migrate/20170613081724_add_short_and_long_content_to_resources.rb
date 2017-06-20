class AddShortAndLongContentToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :short_content, :text
    add_column :resources, :long_content, :text
  end
end
