# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Capybara.default_driver = :webkit
Capybara.javascript_driver = :webkit

Capybara::Webkit.configure do |config|
  config.debug = ENV['WEBKIT_DEBUG'] || false
  config.block_unknown_urls
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.filter_rails_from_backtrace!
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)

    [Resource, List, Network, User].each do |klass|
      klass.__elasticsearch__.create_index!(index: klass.index_name)
    end
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each, elasticsearch: true) do
    reset_all_indices
  end

  config.around(:each, search_indexing_callbacks: false) do |example|
    ClimateControl.modify(ENABLE_SEARCH_INDEX_CALLBACKS: 'false') do
      example.run
    end
  end

  config.around(:each, :worker) do |example|
    Sidekiq::Testing.inline! do
      example.run
    end
  end

  def reset_all_indices
    [Resource, List, Network, User].each do |klass|
      klass.__elasticsearch__.delete_index!(index: klass.index_name)
      klass.__elasticsearch__.create_index!(index: klass.index_name)
    end
  end
end
