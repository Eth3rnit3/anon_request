# frozen_string_literal: true

module AnonRequest
  class Configuration
    def self.test?
      ENV['RUN_RSPEC'].present? || ENV['RACK_ENV'] == 'test' || ENV['RAILS_ENV'] == 'test'
    end

    attr_accessor :shell, :sudo_password

    def initialize
      @shell          = ENV['SHELL']
      @sudo_password  = nil
    end
  end
end
