# frozen_string_literal: true
Sidekiq::Logging.logger = Rails.logger
Sidekiq::Logging.logger.level = Logger::DEBUG

Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379"),
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379"),
  }
end
