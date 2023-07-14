# frozen_string_literal: true

module AnonRequest
  class Configuration
    attr_accessor :shell, :sudo_password

    def initialize
      @shell          = ENV['SHELL']
      @sudo_password  = nil
    end
  end
end
