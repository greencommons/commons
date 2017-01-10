namespace :elasticsearch do
  desc 'Deletes the "resource" index and regenerates it with all records currently in Resource'
  task reset_resource_index: :environment do
    client = Elasticsearch::Client.new(
      url: ENV.fetch('BONSAI_URL', 'http://localhost:9200'), log: true
    )

    if client.indices.exists? index: Resource.index_name
      client.indices.delete index: Resource.index_name
    end

    Resource.__elasticsearch__.create_index!
    Resource.import
  end
end
