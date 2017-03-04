# frozen_string_literal: true
if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider:              "AWS",
      aws_access_key_id:     ENV.fetch("AWS_ACCESS_KEY_ID"),
      aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
      region:                ENV.fetch("AWS_REGION"),
    }
    config.fog_directory  = ENV.fetch("AWS_UPLOADS_BUCKET")
    config.fog_attributes = { "Cache-Control" => "max-age=#{365.day.to_i}" }
  end
end
