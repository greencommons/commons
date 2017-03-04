# frozen_string_literal: true
class AddPublishedAtToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :published_at, :timestamp
  end
end
