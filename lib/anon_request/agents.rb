# frozen_string_literal: true

module AnonRequest
  module Agents
    def load_file(filename)
      File.read("#{__dir__}/agents/#{filename}.txt").split("\n")
    end

    def android
      @android ||= load_file(:android)
    end

    def chrome
      @chrome ||= load_file(:chrome)
    end

    def edge
      @edge ||= load_file(:edge)
    end

    def firefox
      @firefox ||= load_file(:firefox)
    end

    def internet_explorer
      @internet_explorer ||= load_file(:internet_explorer)
    end

    def opera
      @opera ||= load_file(:opera)
    end

    def safari
      @safari ||= load_file(:safari)
    end

    def agents
      @agents ||= [
        android,
        chrome,
        edge,
        firefox,
        internet_explorer,
        opera,
        safari
      ].flatten
    end

    def random_agent
      agents.sample
    end
  end
end
