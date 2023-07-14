module AnonRequest
  module Helpers
    def tor_installed?
      linux_tor_installed? || macos_tor_installed?
    end

    def macos_tor_installed?
      system('brew list | grep -q ^tor$')
    end

    def linux_tor_installed?
      `dpkg -s tor`
      $?.success?
    rescue Errno::ENOENT
      false
    end
  end
end
