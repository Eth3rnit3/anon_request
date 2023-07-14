# frozen_string_literal: true

module AnonRequest
  class Configuration
    def self.test?
      !ENV['RUN_RSPEC'].nil? || ENV['RACK_ENV'] == 'test' || ENV['RAILS_ENV'] == 'test'
    end

    attr_accessor :shell, :sudo_password, :open_vpn_config_path, :open_vpn_stop_timeout, :anon_ip_delay, :rotation
    attr_reader :open_vpn_config_files

    def initialize
      @shell                  = ENV['SHELL']
      @sudo_password          = nil
      @open_vpn_config_path   = "#{__dir__}/open_vpn/configs"
      @open_vpn_config_files  = Dir["#{@open_vpn_config_path}/**/*.ovpn"]
      @anon_ip_delay = 30
      @open_vpn_stop_timeout  = 10
      @rotation               = nil
    end
  end
end
