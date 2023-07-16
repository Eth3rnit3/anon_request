# frozen_string_literal: true

require 'singleton'

module AnonRequest
  module OpenVpn
    class ConfigFile
      attr_reader :name, :path, :username, :password, :creadentials_path, :delay

      def initialize(attributes = {})
        @name             = attributes.fetch(:name)
        @path             = attributes.fetch(:path)
        @username         = attributes.fetch(:username, nil)
        @password         = attributes.fetch(:password, nil)
        @delay            = attributes.fetch(:delay, AnonRequest.configuration.anon_ip_delay)
        @readentials_path = nil

        write_crdentials if auth?
      end

      def data
        @data ||= load_ovpn
      end

      def absolute_path
        p_name = Pathname.new(path)

        if p_name.absolute?
          p_name
        else
          File.expand_path("#{__dir__}/../../../#{p_name}")
        end
      end

      def filename
        File.basename(absolute_path, '.*')
      end

      def load_ovpn
        File.read(absolute_path)
      end

      def auth?
        !username.nil? && !password.nil?
      end

      private

      def write_crdentials
        path = "/tmp/#{filename}.txt"
        ::File.write(path, "#{username}\n#{password}")
        @creadentials_path = path
      end
    end
  end
end
