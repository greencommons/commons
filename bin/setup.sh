#!/usr/bin/env bash

# Sets up the Somawater Rails app. Run this script immediately after cloning the codebase.

# Exit if any subcommand fails
set -e

# Set up configurable environment variables
if [ ! -f '.env' ]; then
  echo '==| creating .env'
  cp ./.env.sample ./.env
fi

echo '==| creating log folder'
mkdir -p log

# Install Gems & Bundler (if req'd)
echo '==| installing gems'

if gem list bundler --installed > /dev/null
then
  gem update bundler
else
  gem install bundler --version '>= 1.13.1'
fi

bundle check > /dev/null || bundle install --binstubs=bin/stubs

echo '==| installing homebrew formulae stuff'
if which brew > /dev/null
then
  brew update
  brew tap Homebrew/bundle
  brew bundle
else
  echo "==| Homebrew is not installed, skipping"
fi


# Check for tools that need to be installed
dependencies='foreman heroku'
for name in $dependencies
do
  if ! which "$name" > /dev/null; then
    echo "==| $name not installed"
    exit 1
  fi
done

# TODO: Ensure Postgres is running

# Set up the database
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

echo "==| setup complete!"
exit 0
