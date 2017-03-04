# frozen_string_literal: true
if Rails.env.test?
  require "rubocop/rake_task"

  desc "Run Rubocop to lint code and enforce style guide"

  task :rubocop do
    RuboCop::RakeTask.new
  end
end
