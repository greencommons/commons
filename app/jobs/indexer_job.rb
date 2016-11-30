class IndexerJob
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: true

  def perform(action, model_name, id)
    @action = action
    @id = id
    @model_name = model_name

    Rails.logger.tagged('ELASTICSEARCH') do
      Rails.logger.warn(
        "Hey! Performing a #{action} on a #{model_name} record with id# #{record.id}"
      )
    end

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
