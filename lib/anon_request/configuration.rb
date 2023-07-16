# frozen_string_literal: true

require 'yaml'

module AnonRequest
  class Configuration
    def self.test?
      !ENV['RUN_RSPEC'].nil? || ENV['RACK_ENV'] == 'test' || ENV['RAILS_ENV'] == 'test'
    end

    attr_accessor :shell, :sudo_password, :open_vpn_stop_timeout, :anon_ip_delay, :rotation, :use_tor, :tor_proxy, :open_vpn_config_file

    def initialize
      @shell                  = ENV['SHELL']
      @sudo_password          = nil
      @open_vpn_config_file   = "#{__dir__}/../../config/open_vpn.yml"
      @anon_ip_delay          = 30
      @open_vpn_stop_timeout  = 10
      @rotation               = nil
      @use_tor                = false
      @tor_proxy              = 'socks5://127.0.0.1:9050'
    end

    def open_vpn_config_files
      @open_vpn_config_files ||= load_open_vpn_config_files
    end

    private

    def load_open_vpn_config_files
      ::YAML.load_file(open_vpn_config_file)['default'].map do |open_vpn_config_data|
        OpenVpn::ConfigFile.new(open_vpn_config_data.transform_keys(&:to_sym))
      end
    end
  end
end
