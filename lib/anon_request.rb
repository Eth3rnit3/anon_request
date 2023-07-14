# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

require_relative "anon_request/version"

module AnonRequest
  class Error < StandardError; end

  class Client < ::Net::HTTP
  end
end
