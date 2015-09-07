#-*- mode: ruby -*-

require File.expand_path( '../lib/leafy/logger/version', __FILE__ )

Gem::Specification.new do |s|
  s.name = 'leafy-logger'
  s.version = Leafy::Logger::VERSION
  s.author = 'christian meier'
  s.email = [ 'christian.meier@lookout.com' ]

  s.platform = 'java'
  s.license = 'MIT'
  s.summary = %q(adding logback to leafy)
  s.homepage = 'https://github.com/lookout/leafy'
  s.description = %q(adding logback to leafy with yaml configuration and bridges to log4j and jul)

  s.files = `git ls-files`.split($/)

  # exclude the dependencies which come with jruby itself
  # TODO needs something in jar-dependencies since those jruby dependencies can
  # be different from version to version

  s.requirements << 'jar io.dropwizard:dropwizard-logging, 0.8.0-rc5, [ joda-time:joda-time ]'
  s.requirements << 'jar io.dropwizard:dropwizard-configuration, 0.8.0-rc5, [ org.yaml:snakeyaml ]'

  s.add_runtime_dependency 'jar-dependencies', '~> 0.1'
  s.add_runtime_dependency 'leafy-metrics', "~> #{Leafy::Logger::VERSION}"
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'yard', '~> 0.8.7'
  s.add_development_dependency 'rake', '~> 10.2'
end

# vim: syntax=Ruby
