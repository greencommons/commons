# frozen_string_literal: true
class AddPrivacyAndUrlToResources < ActiveRecord::Migration[5.0]
  def change
    add_column :resources, :privacy, :integer, default: 0, null: false
    add_column :resources, :url, :string
  end
end
