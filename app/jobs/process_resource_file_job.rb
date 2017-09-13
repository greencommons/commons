class ProcessResourceFileJob
  include Sidekiq::Worker
  sidekiq_options queue: 'file', retry: true

  def perform(resource_id)
    Rails.logger.tagged('FILE PROCESSING') do
      Rails.logger.warn(
        "Hey! processing file from resource #{resource_id}"
      )
    end

    resource = Resource.find(resource_id)
    Resources::FileProcessor.new(resource).call
  end
end
