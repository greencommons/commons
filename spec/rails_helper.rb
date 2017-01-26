# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.filter_rails_from_backtrace!
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true

  config.before(:suite) do
    [Resource, List, Group].each do |klass|
      klass.__elasticsearch__.create_index!(index: klass.index_name)
    end
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
    [Resource, List, Group].each do |klass|
      klass.__elasticsearch__.delete_index!(index: klass.index_name)
      klass.__elasticsearch__.create_index!(index: klass.index_name)
    end
  end
end
