# frozen_string_literal: true

require "faraday"
require "uri"
require "json"
require "byebug"

Dir["#{File.dirname(__FILE__)}/anon_request/**/*.rb"].each { |file| require file }

module AnonRequest
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Error < StandardError; end
  
  class Client
    include Agents

    attr_reader :connection, :request, :response

    def initialize(base_url)
      @connection = Faraday.new(url: base_url) do |faraday|
        faraday.headers['User-Agent'] = random_agent
        faraday.adapter Faraday.default_adapter
      end
      @request = nil
      @response = nil
    end

    def get(path, params = {})
      @response = connection.get(path, params) do |request|
        @request = request
      end
    end

    def post(path, body = {})
      @response = connection.get(path, params) do |request|
        @request = request
      end
    end
  end
end