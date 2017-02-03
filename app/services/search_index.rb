class SearchIndex
  def self.index_name(klass)
    "#{klass.name.pluralize.downcase}-#{Rails.env}"
  end

  def self.log_elasticsearch_warning(message)
    Rails.logger.tagged('ELASTICSEARCH') do
      Rails.logger.warn(message)
    end
  end

  def initialize(model_name:, id:, changed: nil)
    @model_name = model_name
    @id = id
    @changed = changed
  end

  def add
    perform { record.__elasticsearch__.index_document }
  end

  def update
    perform do
      data = elasticsearch_hash.merge(body: { doc: changes })
      Elasticsearch::Model.client.update(data)
    end
  rescue Elasticsearch::Transport::Transport::Errors::NotFound
    add
  end

  def remove
    perform { Elasticsearch::Model.client.delete(elasticsearch_hash) }
  rescue Elasticsearch::Transport::Transport::Errors::NotFound
  end

  private

  attr_reader :id, :model_name, :changed

  def record
    @_record ||= model_name.constantize.find_by(id: id)
  end

  def changes
    record.__elasticsearch__.as_indexed_json.select do |k, _|
      changed.include?(k.to_s)
    end
  end

  def elasticsearch_hash
    {
      index: model_name.constantize.index_name,
      type:  model_name.downcase,
      id:    id
    }
  end

  def perform
    search_index_callbacks_enabled? ? yield : log_callback_warning
  end

  def search_index_callbacks_enabled?
    ENV.fetch('ENABLE_SEARCH_INDEX_CALLBACKS', true) != 'false'
  end

  def log_callback_warning
    self.class.log_elasticsearch_warning(
      "Note: ElasticSearch's Model callbacks have been disabled"
    )
  end
end
