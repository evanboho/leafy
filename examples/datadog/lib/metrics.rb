require 'leafy/metrics'
require 'leafy/metrics/reporter'
require_relative 'java_gauge'
require_relative 'ruby_gauge'

metrics = Leafy::Metrics::Registry.new
my = metrics.register_gauge( 'leafy.demo.java.usec', JavaGauge.new )
my = metrics.register_gauge( 'leafy.demo.ruby.usec', RubyGauge.new )

transport =  Java::OrgCourseraMetricsDatadogTransport::UdpTransport::Builder.new.build

reporter = metrics.reporter_builder( Java::OrgCourseraMetricsDatadog::DatadogReporter ).withTransport(transport).build

reporter.start(1, Leafy::Metrics::Reporter::SECONDS)

sleep 3

reporter.stop
