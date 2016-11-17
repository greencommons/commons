class SearchIndex
  def self.add(record)
    if search_index_callbacks_enabled?
      IndexerJob.perform_async(:index, record.id)
    end
  end

  def self.remove(record)
    if search_index_callbacks_enabled?
      IndexerJob.perform_async(:delete, record.id)
    end
  end

  def self.search_index_callbacks_enabled?
    Rails.logger.tagged('ELASTICSEARCH') do
      Rails.logger.warn(
        "Note: ElasticSearch's Model callbacks have been disabled"
      )
    end

    ENV.fetch('ENABLE_SEARCH_INDEX_CALLBACKS', true) != 'false'
  end
end
