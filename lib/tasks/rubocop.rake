if Rails.env.test?
  require 'rubocop/rake_task'

  desc 'Run Rubocop to lint code and enforce style guide'

  task :rubocop do
    require 'rubocop'
    cli = RuboCop::CLI.new
    cli.run(%w(--rails))
  end
end
