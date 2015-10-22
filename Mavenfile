#-*- mode: ruby -*-

gemspec

packaging :pom

modules ['leafy-metrics', 'leafy-health', 'leafy-logger', 'leafy-rack']

jruby_plugin! :gem do
  execute_goal :id => 'build gem', :package, :phase => :package
  execute_goal :id => 'push to rubygems.org', :push, :phase => :deploy
end
