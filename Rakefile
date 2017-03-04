# frozen_string_literal: true
require_relative "config/application"

Rails.application.load_tasks

task default: :spec

if Rails.env.test?
  task(:default).prerequisites << task(:rubocop)
end
