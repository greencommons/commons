require_relative 'boot'

require 'rails/all'
require './lib/middleware/catch_json_parse_errors.rb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Commons
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    require 'elasticsearch/rails/instrumentation'
  end
end

Rails.application.configure do
  config.autoload_paths << Rails.root.join('lib')
  config.middleware.insert_before Rack::Head, CatchJsonParseErrors
end
