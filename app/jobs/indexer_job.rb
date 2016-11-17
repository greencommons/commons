class IndexerJob
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: true

  def perform(action, model_name, id)
    @action = action
    @id = id
    @model_name = model_name

    record.__elasticsearch__.send(index_action)
  end

  private

  attr_reader :action, :id, :model_name

  def record
    model_name.constantize.find(id)
  end

  def index_action
    "#{action}_document".to_sym
  end
end
