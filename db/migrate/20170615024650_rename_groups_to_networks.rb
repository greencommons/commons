class RenameGroupsToNetworks < ActiveRecord::Migration[5.0]
  def change
    rename_table :groups, :networks
    rename_table :groups_users, :networks_users
    rename_column :networks_users, :group_id, :network_id
    remove_column :networks, :url, :string
    remove_column :networks, :email, :string
  end
end
