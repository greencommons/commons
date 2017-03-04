# frozen_string_literal: true
class AddTimestampsToGroupsUsers < ActiveRecord::Migration[5.0]
  def change
    add_column(:groups_users, :created_at, :datetime)
    add_column(:groups_users, :updated_at, :datetime)
  end
end
