# frozen_string_literal: true
class AddPublishedAtToLists < ActiveRecord::Migration[5.0]
  def change
    add_column :lists, :published_at, :timestamp
  end
end
