class UpdateIndexJob
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch', retry: true

  def perform(model_name, id, changed)
    Rails.logger.tagged('ELASTICSEARCH') do
      Rails.logger.warn(
        "Hey! Updating the #{model_name} index for record id# #{id}"
      )
    end

    SearchIndex.new(model_name: model_name, id: id, changed: changed).update
  end
end
