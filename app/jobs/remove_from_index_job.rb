# frozen_string_literal: true
class RemoveFromIndexJob
  include Sidekiq::Worker
  sidekiq_options queue: "elasticsearch", retry: true

  def perform(model_name, id)
    Rails.logger.tagged("ELASTICSEARCH") do
      Rails.logger.warn(
        "Hey! Removing from index: a #{model_name} record with id# #{id}",
      )
    end

    SearchIndex.new(model_name: model_name, id: id).remove
  end
end
