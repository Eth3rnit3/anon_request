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
      @request_count    = 0
      start_vpn
    end

    def stop_vpn
      return true if AnonRequest::Configuration.test?

      open_vpn.kill
    end

    def get(path, params = {})
      inc_rotation
      @response = connection.get(path, params) do |request|
        @request = request
      end
    end

    def post(path, body = {})
      inc_rotation
      @response = connection.get(path, body) do |request|
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

    def rotate
      connection.headers['User-Agent'] = random_agent
      stop_vpn
      @vpn_config_file = AnonRequest.configuration.open_vpn_config_files.sample
      start_vpn
    end

    def inc_rotation
      @request_count += 1
      return unless AnonRequest.configuration.rotation
      return unless @request_count == AnonRequest.configuration.rotation

      @request_count = 0
      rotate
    end
  end
end
