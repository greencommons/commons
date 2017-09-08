namespace :elasticsearch do
  namespace :reset do
    def reset_index(klass)
      client = Elasticsearch::Client.new(
        url: ENV.fetch('BONSAI_URL', 'http://localhost:9200'), log: true
      )

      if client.indices.exists? index: klass.index_name
        client.indices.delete index: klass.index_name
      end

      klass.__elasticsearch__.create_index! force: true

      begin
        klass.import
      rescue Faraday::ConnectionFailed => e
        ap e
        ap 'Indexing records one at a time...'
        klass.all.each { |r| r.__elasticsearch__.index_document }
      end
    end

    desc 'Deletes the "resource", "network", "user" and "list" indices and regenerates it with all records'
    task all_indices: :environment do
      [Resource, Network, List, User].each { |klass| reset_index(klass) }
    end

    desc 'Deletes the "resource" index and regenerates it with all records currently in Resource'
    task resource_index: :environment do
      reset_index(Resource)
    end

    desc 'Deletes the "network" index and regenerates it with all records currently in Network'
    task network_index: :environment do
      reset_index(Network)
    end

    desc 'Deletes the "list" index and regenerates it with all records currently in List'
    task list_index: :environment do
      reset_index(List)
    end

    desc 'Deletes the "user" index and regenerates it with all records currently in List'
    task user_index: :environment do
      reset_index(User)
    end
  end

  namespace :create do
    def create_index(klass)
      ap "Creating #{klass.name} index"
      klass.__elasticsearch__.create_index!
      ap "Indexing #{klass.name} records"
      klass.import
    end

    desc 'Creates the "resource", "network", "user" and "list" indices and regenerates it with all records'
    task all_indices: :environment do
      [Resource, Network, List, User].each { |klass| create_index(klass) }
    end

    desc 'Creates the "resource" index and regenerates it with all records currently in Resource'
    task resource_index: :environment do
      create_index(Resource)
    end

    desc 'Creates the "network" index and regenerates it with all records currently in Network'
    task network_index: :environment do
      create_index(Network)
    end

    desc 'Creates the "list" index and regenerates it with all records currently in List'
    task list_index: :environment do
      create_index(List)
    end

    desc 'Creates the "user" index and regenerates it with all records currently in List'
    task user_index: :environment do
      create_index(User)
    end
  end
end
