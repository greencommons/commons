namespace :elasticsearch do
  desc 'Delete the "resource" index'
  task :delete_resource_index do
    client = Elasticsearch::Client.new(
      url: ENV.fetch('BONSAI_URL', 'http://localhost:9200'), log:true
    )
    client.indices.delete index: 'resources'
  end
end
