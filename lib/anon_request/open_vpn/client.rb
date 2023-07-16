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
        @shell              = AnonRequest.configuration.shell
        @pid                = nil
        @deconnection_delay = AnonRequest.configuration.open_vpn_stop_timeout
      end

      def run(vpn_config)
        raise NoConfigFilerror  if vpn_config.nil? || !File.exist?(vpn_config.absolute_path)
        return :success         if AnonRequest::Configuration.test?

        cmd = command(vpn_config)

        puts cmd
        @pid = spawn(cmd)
        Process.detach(@pid)

        @pid
      end

      def command(vpn_config)
        command = "openvpn --config #{vpn_config.absolute_path}"
        command = "echo #{AnonRequest.configuration.sudo_password} | sudo -S  #{command}" if AnonRequest.configuration.sudo_password
        command = "#{command} --auth-user-pass #{vpn_config.creadentials_path}" if vpn_config.auth?

        command
      end

      def kill
        Timeout.timeout(@deconnection_delay) do
          puts "[#{self.class}] - Terminate process #{@pid}"
          Process.kill('TERM', @pid)
          puts "[#{self.class}] - Terminated process #{@pid}"
        end
      rescue Timeout::Error
        puts "[#{self.class}] - Kill process #{@pid}"
        Process.kill('TERM', @pid)
        puts "[#{self.class}] - Killed process #{@pid}"
      end

      def force_kill
        raise NoPasswodError if AnonRequest.configuration.sudo_password.nil?

        system("echo #{AnonRequest.configuration.sudo_password} | sudo -S  sudo killall openvpn")
      end
    end
  end
end
