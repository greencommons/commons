namespace :elasticsearch do
  def reset_index(klass)
    client = Elasticsearch::Client.new(
      url: ENV.fetch('BONSAI_URL', 'http://localhost:9200'), log: true
    )

    if client.indices.exists? index: klass.index_name
      client.indices.delete index: klass.index_name
    end

    klass.__elasticsearch__.create_index!

    begin
      klass.import
    rescue Faraday::ConnectionFailed => e
      ap e
      ap 'Indexing records one at a time...'
      klass.all.each { |r| r.__elasticsearch__.index_document }
    end
  end

  desc 'Deletes the "resource", "group" and "list" indices and regenerates it with all records'
  task reset_all_indices: :environment do
    [Resource, Group, List].each { |klass| reset_index(klass) }
  end

  desc 'Deletes the "resource" index and regenerates it with all records currently in Resource'
  task reset_resource_index: :environment do
    reset_index(Resource)
  end

  desc 'Deletes the "group" index and regenerates it with all records currently in Group'
  task reset_group_index: :environment do
    reset_index(Group)
  end

  desc 'Deletes the "list" index and regenerates it with all records currently in List'
  task reset_list_index: :environment do
    reset_index(List)
  end
end
