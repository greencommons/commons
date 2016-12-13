class AddToIndexJob
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: true

  def perform(model_name, id)
    Rails.logger.tagged('ELASTICSEARCH') do
      Rails.logger.warn(
        "Hey! Adding from index: a #{model_name} record with id# #{id}"
      )
    end

    SearchIndex.new(model_name: model_name, id: id).add
  end
end
