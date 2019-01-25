lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'yavdb/version'

Gem::Specification.new do |spec|
  spec.name = 'yavdb'
  spec.version = YAVDB::VERSION
  spec.authors = ['Rodrigo Fernandes']
  spec.email = ['rodrigo.fernandes@tecnico.ulisboa.pt']
  spec.summary = 'The Free and Open Source vulnerability database.'
  spec.description = '
    Yet Another Vulnerability Database
    The Free and Open Source vulnerability database.
  '
  spec.homepage = 'https://github.com/rtfpessoa/yavdb'
  spec.license = 'AGPL-3.0+'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|database)/}) }
  spec.bindir = 'bin'
  spec.executables = ['yavdb', 'vulndb', 'vulnerabilitydb']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.7'

  # Development
  spec.add_development_dependency 'codacy-coverage'
  spec.add_development_dependency 'rake', ['~> 12.3']
  spec.add_development_dependency 'rspec', ['~> 3.8']
  spec.add_development_dependency 'rspec_junit_formatter', ['~> 0.4']
  spec.add_development_dependency 'simplecov'

  # Linters
  spec.add_development_dependency 'rubocop', ['~> 0.59']
  spec.add_development_dependency 'rubocop-rspec', ['~> 1.29']

  # Runtime
  spec.add_runtime_dependency 'execjs', ['~> 2.7.0']
  spec.add_runtime_dependency 'json', ['~> 2.1']
  spec.add_runtime_dependency 'kramdown', ['~> 1.17']
  spec.add_runtime_dependency 'oga', ['~> 2.15']
  spec.add_runtime_dependency 'semantic_interval', ['~> 0.1']
  spec.add_runtime_dependency 'therubyracer', ['~> 0.12']
  spec.add_runtime_dependency 'thor', ['~> 0.20']
end
