class SearchIndex
  def self.index_name(record)
    "#{record.class.name.pluralize.downcase}-#{Rails.env}"
  end

  def self.log_elasticsearch_warning(message)
    Rails.logger.tagged('ELASTICSEARCH') do
      Rails.logger.warn(message)
    end
  end

  def initialize(model_name:, id:)
    @model_name = model_name
    @id = id
  end

  def add
    if search_index_callbacks_enabled?
      record = model_name.constantize.find(id)
      record.__elasticsearch__.index_document
    else
      log_callback_warning
    end
  end

  def remove
    if search_index_callbacks_enabled?
      Elasticsearch::Model.client.delete(
        index: model_name.constantize.index_name,
        type: model_name.downcase,
        id: id,
      )
    else
      log_callback_warning
    end
  end

  private

  attr_reader :id, :model_name

  def search_index_callbacks_enabled?
    ENV.fetch('ENABLE_SEARCH_INDEX_CALLBACKS', true) != 'false'
  end

  def log_callback_warning
    self.class.log_elasticsearch_warning(
      "Note: ElasticSearch's Model callbacks have been disabled"
    )
  end
end
