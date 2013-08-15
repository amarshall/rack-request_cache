# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/request_cache/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-request_cache'
  spec.version       = Rack::RequestCache::VERSION
  spec.authors       = ['Andrew Marshall']
  spec.email         = ['andrew@johnandrewmarshall.com']
  spec.description   = %q(Provides a caching layer that exists only within a single Rack request.)
  spec.summary       = %q(Provides a caching layer that exists only within a single Rack request.)
  spec.homepage      = 'http://johnandrewmarshall.com/projects/rack-request_cache'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
