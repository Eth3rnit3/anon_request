# frozen_string_literal: true

require 'anon_request'
require 'webmock/rspec'
require 'simplecov'
require 'simplecov-shield'

ENV['RUN_RSPEC'] = 'true'

SimpleCov.start do
  add_filter '/bin/'
  add_filter '/spec/'
  formatter SimpleCov::Formatter::ShieldFormatter
end

WebMock.disable_net_connect!(allow_localhost: true)

def stub_api_get_call
  stub_request(:get, /api.example.com/)
    .to_return(status: 200, body: { success: true }.to_json)
end

def stub_api_post_call
  stub_request(:post, /api.example.com/)
    .to_return(status: 200, body: { success: true }.to_json)
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
