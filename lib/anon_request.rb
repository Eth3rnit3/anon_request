# frozen_string_literal: true

require 'faraday'
require 'uri'
require 'json'
require 'byebug'

Dir["#{File.dirname(__FILE__)}/anon_request/**/*.rb"].sort.each { |file| require file }

module AnonRequest
  class << self
    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
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

      @vpn_config_file  = AnonRequest.configuration.open_vpn_config_files.sample
      @request          = nil
      @response         = nil

      start_vpn
    end

    def stop_vpn
      open_vpn.kill
    end

    def get(path, params = {})
      @response = connection.get(path, params) do |request|
        @request = request
      end
    end

    def post(path, _body = {})
      @response = connection.get(path, params) do |request|
        @request = request
      end
    end

    private

    def open_vpn
      @open_vpn ||= AnonRequest::OpenVpn::Client.instance
    end

    def start_vpn
      return true if AnonRequest::Configuration.test?

      open_vpn.run(@vpn_config_file)
    end
  end
end
