# frozen_string_literal: true

require 'faraday'
require 'faraday/net_http_persistent'
require 'socksify'
require 'socksify/http'
require 'uri'
require 'json'
require 'byebug'

Dir["#{File.dirname(__FILE__)}/anon_request/**/*.rb"].sort.each { |file| require file }

Socksify.debug = true

class Faraday::Adapter::NetHttp # rubocop:disable Style/ClassAndModuleChildren
  def net_http_connection(env)
    proxy = env[:request][:proxy]
    if proxy && proxy.uri.scheme == 'socks5'
      proxy_class(proxy)
    else
      Net::HTTP
    end.new(env[:url].hostname, env[:url].port || (env[:url].scheme == 'https' ? 443 : 80))
  end

  def proxy_class(proxy)
    TCPSocket.socks_username = proxy.uri.user if proxy.uri.user
    TCPSocket.socks_password = proxy.uri.password if proxy.uri.password
    Net::HTTP::SOCKSProxy(proxy[:uri].host, proxy[:uri].port)
  end
end

module AnonRequest
  class << self
    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    yield(configuration)
  end

  class Client
    include Helpers
    include Errors
    include Agents

    attr_reader :connection, :request, :response, :vpn_config

    def initialize(base_url)
      tor_proxy     = URI(AnonRequest.configuration.tor_proxy)
      proxy_options = nil

      if AnonRequest.configuration.use_tor
        raise Errors::TorNotInstalled unless tor_installed?

        proxy_options = {
          uri: AnonRequest.configuration.tor_proxy,
          user: tor_proxy.user,
          password: tor_proxy.password
        }
      end

      @connection = Faraday.new(url: base_url, proxy: proxy_options) do |faraday|
        faraday.headers['User-Agent'] = random_agent

        if AnonRequest.configuration.use_tor
          faraday.adapter Faraday::Adapter::NetHttp
        else
          faraday.adapter Faraday.default_adapter
        end
      end

      @vpn_config       = AnonRequest.configuration.open_vpn_config_files.sample
      @request          = nil
      @response         = nil
      @request_count    = 0
      @real_ip_address  = ip_address
      @connection_delay = @vpn_config.delay

      start_vpn
    end

    def stop_vpn
      return true if AnonRequest::Configuration.test?

      open_vpn.kill
    end

    def get(path, params = {})
      Timeout.timeout(@connection_delay) { sleep 5 until anon? }

      inc_rotation
      @response = connection.get(path, params) do |request|
        @request = request
      end
    end

    def post(path, body = {})
      Timeout.timeout(@connection_delay) { sleep 5 until anon? }

      inc_rotation
      @response = connection.get(path, body) do |request|
        @request = request
      end
    end

    # private

    def ip_address
      Faraday.get('https://ipinfo.io/ip').body
    end

    def anon?
      return ip_address != @real_ip_address unless AnonRequest.configuration.use_tor

      tor?
    end

    def tor?
      Timeout.timeout(5) do
        response = connection.get('https://check.torproject.org')
        return true if response.body.match?(/Congratulations. This browser is configured to use Tor/)

        return false
      end
    rescue Timeout::Error, Faraday::ConnectionFailed
      false
    end

    def open_vpn
      @open_vpn ||= AnonRequest::OpenVpn::Client.instance
    end

    def start_vpn
      return true if AnonRequest::Configuration.test?

      open_vpn.run(@vpn_config)
    end

    def rotate
      connection.headers['User-Agent'] = random_agent
      stop_vpn
      @vpn_config       = AnonRequest.configuration.open_vpn_config_files.sample
      @connection_delay = vpn_config.delay
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
