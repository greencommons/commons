# frozen_string_literal: true
class ChangeResourceMetadataToRequired < ActiveRecord::Migration[5.0]
  def up
    remove_column :resources, :metadata
    add_column :resources, :metadata, :jsonb, null: false, default: {}
  end

  def down
    remove_column :resources, :metadata
    add_column :resources, :metadata, :json, null: true, default: nil
  end
end
