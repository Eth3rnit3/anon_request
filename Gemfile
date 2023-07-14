# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in anon_request.gemspec
gemspec

gem 'faraday-net_http_persistent', '~> 2.0'
gem 'rake', '~> 13.0'
gem 'reek', '~> 6.0'
gem 'socksify'

gem 'rubocop', '~> 1.7'

group :development, :test do
  gem 'rubycritic', require: false
  gem 'rubycritic-small-badge', require: false
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'simplecov', require: false
  gem 'simplecov-shield', git: 'https://github.com/JoshSinyor/simplecov-shield.git', branch: 'remove-uri-escape', require: false
  gem 'webmock'
end
