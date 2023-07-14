# frozen_string_literal: true

require_relative 'lib/anon_request/version'

Gem::Specification.new do |spec|
  spec.name          = 'anon_request'
  spec.version       = AnonRequest::VERSION
  spec.authors       = ['Eth3rnit3']
  spec.email         = ['eth3rnit3@gmail.com']

  spec.summary       = 'HTTP Client to make anonymous request'
  spec.description   = 'HTTP Client to make anonymous request'
  spec.homepage      = 'https://github.com/Eth3rnit3/anon_request'
  spec.required_ruby_version = '>= 2.4.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Eth3rnit3/anon_request'
  spec.metadata['changelog_uri'] = 'https://github.com/Eth3rnit3/anon_request/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'byebug', '~> 11.1.3'
  spec.add_dependency 'faraday', '~> 2.7.10'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
