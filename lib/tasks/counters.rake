namespace :counters do
  desc 'Reset all networks counter caches'
  task reset_networks: :environment do
    Network.find_each do |network|
      Network.reset_counters(network.id, :networks_users_count, :lists_items_count)
    end
  end

  desc 'Reset all resources counter caches'
  task reset_resources: :environment do
    Resource.find_each { |resource| Resource.reset_counters(resource.id, :lists_items_count) }
  end

  desc 'Reset all lists counter caches'
  task reset_lists: :environment do
    List.find_each { |list| List.reset_counters(list.id, :lists_items_count) }
  end
end
