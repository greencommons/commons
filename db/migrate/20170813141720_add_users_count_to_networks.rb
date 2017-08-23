class AddUsersCountToNetworks < ActiveRecord::Migration[5.0]
  def change
    add_column :networks, :networks_users_count, :integer, default: 0
  end
end
