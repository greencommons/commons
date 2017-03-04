# frozen_string_literal: true
class AddIdAndAdminToGroupsUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :groups_users, :id, :primary_key
    add_column :groups_users, :admin, :boolean, null: false, default: false

    remove_index :groups_users, :group_id
    add_index :groups_users, [:group_id, :user_id], using: :btree, unique: true
  end
end
