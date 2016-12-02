namespace :elasticsearch do
  desc 'Deletes the "resource" index and regenerates it with all records currently in Resource'
  task :reset_resource_index do
    client = Elasticsearch::Client.new(
      url: ENV.fetch('BONSAI_URL', 'http://localhost:9200'), log:true
    )
    client.indices.delete index: 'resources'
    Resource.__elasticsearch__.create_index!
    Resource.import
  end
end
