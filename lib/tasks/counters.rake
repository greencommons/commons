namespace :counters do
  desc 'Reset all networks counter caches'
  task reset_networks: :environment do
    Network.find_each { |network| Network.reset_counters(network.id, :networks_users_count) }
    Post.find_each { |post| Post.reset_counters(post.id, :comments) }
  end
end
