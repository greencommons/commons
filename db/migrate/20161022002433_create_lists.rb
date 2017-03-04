# frozen_string_literal: true
class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|
      t.string      :name, null: false
      t.string      :description
      t.references  :owner, polymorphic: true, index: true, null: false

      t.timestamps
    end
    create_table :lists_resources, id: false do |t|
      t.belongs_to  :list
      t.belongs_to  :resource
    end
  end
end
