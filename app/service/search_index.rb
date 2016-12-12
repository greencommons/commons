class SearchIndex
  def initialize(model_name:, id:, async: false)
    @model_name = model_name
    @id = id
    @async = async
  end

  def add
    if async
      add_to_index_asynchronously
    else
      record = model_name.constantize.find(id)
      record.__elasticsearch__.index_document
    end
  end

  def remove
    if async
      remove_from_index_asynchronously
    else
      Elasticsearch::Model.client.delete(
        index: model_name.constantize.index_name,
        type: model_name.downcase,
        id: id,
      )
    end
  end

  private

  attr_reader :async, :id, :model_name

  def add_to_index_asynchronously
    if search_index_callbacks_enabled?
      AddToIndexJob.perform_async(model_name, id)
    else
      log_warning
    end
  end

  def remove_from_index_asynchronously
    if search_index_callbacks_enabled?
      RemoveFromIndexJob.perform_async(model_name, id)
    else
      log_warning
    end
  end

  def search_index_callbacks_enabled?
    ENV.fetch('ENABLE_SEARCH_INDEX_CALLBACKS', true) != 'false'
  end

  def log_warning
    Rails.logger.tagged('ELASTICSEARCH') do
      Rails.logger.warn(
        "Note: ElasticSearch's Model callbacks have been disabled"
      )
    end
  end
end
