# frozen_string_literal: true
class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string  :name, null: false
      t.string  :short_description
      t.text    :long_description
      t.string  :url
      t.string  :email
      t.json    :metadata

      t.timestamps
    end

    create_table :groups_users, id: false do |t|
      t.belongs_to :user,   index: true
      t.belongs_to :group,  index: true
    end
  end
end
