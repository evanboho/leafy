#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'leafy-complete'
  s.version = '0.3.2'
  s.author = 'Christian Meier'
  s.email = [ 'christian.meier@lookout.com' ]

  s.platform = 'java'
  s.license = 'MIT'
  s.summary = %q('meta' gem which pulls all the leafy gems)
  s.homepage = 'https://github.com/lookout/leafy'
  s.description = %q(this gem has no code only dependencies to all the other leafy gems. it is meant as convenient way to pull in all leafy gems in one go)

  s.files = ['leafy-complete.gemspec', 'README.md', 'LICENSE']

  s.add_runtime_dependency 'leafy-metrics', "~> #{s.version}"
  s.add_runtime_dependency 'leafy-health', "~> #{s.version}"
  s.add_runtime_dependency 'leafy-rack', "~> #{s.version}"
  s.add_runtime_dependency 'leafy-logger', "~> #{s.version}"
end

# vim: syntax=Ruby
