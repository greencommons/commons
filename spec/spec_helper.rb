require 'factory_girl_rails'
require 'sidekiq/testing'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = 'tmp/examples.txt'
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
