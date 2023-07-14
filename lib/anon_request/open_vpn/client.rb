# frozen_string_literal: true

require 'singleton'

module AnonRequest
  module OpenVpn
    class NoPasswodError < StandardError; end
    class Client
      include Singleton

      def initialize
        @executor = "#{__dir__}/client.sh"
        @shell    = AnonRequest.configuration.shell
        @sudo_pwd = AnonRequest.configuration.sudo_password
      end

      def run(config_file)
        raise NoPasswodError if @sudo_pwd.nil?


        system("#{@shell} #{@executor} #{config_file} #{@sudo_pwd}")
      end
    end
  end
end
