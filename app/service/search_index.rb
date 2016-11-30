class SearchIndex
  def self.add(record)
    if search_index_callbacks_enabled?
      IndexerJob.perform_async(:index, record.class.name, record.id)
    end
  end

  def self.remove(record)
    if search_index_callbacks_enabled?
      IndexerJob.perform_async(:delete, record.class.name, record.id)
    end
  end

  def self.search_index_callbacks_enabled?
    enabled = ENV.fetch('ENABLE_SEARCH_INDEX_CALLBACKS', true) != 'false'

    unless enabled
      Rails.logger.tagged('ELASTICSEARCH') do
        Rails.logger.warn(
          "Note: ElasticSearch's Model callbacks have been disabled"
        )
      end
    end

    enabled
  end
end
