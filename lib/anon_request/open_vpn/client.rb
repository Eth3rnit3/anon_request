# frozen_string_literal: true

require 'singleton'

module AnonRequest
  module OpenVpn
    class NoArgumentrror < StandardError; end
    class NoConfigFilerror < StandardError; end
    class NoPasswodError < StandardError; end

    class Client
      include Singleton

      def initialize
        @executor = "#{__dir__}/client.sh"
        @shell    = AnonRequest.configuration.shell
        @sudo_pwd = AnonRequest.configuration.sudo_password
        @pid      = nil
      end

      def run(config_file)
        raise NoPasswodError    if @sudo_pwd.nil?
        raise NoConfigFilerror  if config_file.nil? || !File.exist?(config_file)
        return :success         if AnonRequest::Configuration.test?

        command = "#{@shell} #{@executor} #{config_file} #{@sudo_pwd}"

        @pid = spawn(command)
        Process.detach(@pid)

        @pid
      end

      def kill
        Timeout.timeout(AnonRequest.configuration.open_vpn_stop_timeout) do
          puts "[#{self.class}] - Terminate process #{@pid}"
          Process.kill('TERM', @pid)
          puts "[#{self.class}] - Terminated process #{@pid}"
        end
      rescue Timeout::Error
        puts "[#{self.class}] - Kill process #{@pid}"
        Process.kill('TERM', @pid)
        puts "[#{self.class}] - Killed process #{@pid}"
      end
    end
  end
end
