# frozen_string_literal: true
class AddContentToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :content, :jsonb, null: false, default: {}
  end
end
