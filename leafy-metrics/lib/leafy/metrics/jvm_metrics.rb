require 'leafy/metrics'

module Leafy
  module Metrics
    module JvmMetrics

      # registers some buffer pool metrics. more details see https://github.com/dropwizard/metrics/blob/master/metrics-jvm/src/main/java/com/codahale/metrics/jvm/BufferPoolMetricSet.java#L19
      #
      # @param [Leafy::Metrics::Registry] where to register the metrics
      # @param [String] basename
      def self.register_buffer_pool_metrics( registry, name )
        # use the same MBenServer as JRuby does
        registry.register_metric( name, com.codahale.metrics.jvm.BufferPoolMetricSet.new( java.lang.management.ManagementFactory.getPlatformMBeanServer ) )
      end

      # registers some memory usage gauges. more details see https://github.com/dropwizard/metrics/blob/master/metrics-jvm/src/main/java/com/codahale/metrics/jvm/MemoryUsageGaugeSet.java#L18
      #
      # @param [Leafy::Metrics::Registry] where to register the metrics
      # @param [String] basename
      def self.register_memory_usage_gauges( registry, name )
        registry.register_metric( name, com.codahale.metrics.jvm.MemoryUsageGaugeSet.new )
      end

      # registers some garbage collection metrics. more details see https://github.com/dropwizard/metrics/blob/master/metrics-jvm/src/main/java/com/codahale/metrics/jvm/GarbageCollectorMetricSet.java#L15
      #
      # @param [Leafy::Metrics::Registry] where to register the metrics
      # @param [String] basename
      def self.register_garbage_collector_metrics( registry, name )
        registry.register_metric( name, com.codahale.metrics.jvm.GarbageCollectorMetricSet.new )
      end

      # registers some (java) thread state gauges. more details see https://github.com/dropwizard/metrics/blob/master/metrics-jvm/src/main/java/com/codahale/metrics/jvm/ThreadStatesGaugeSet.java#L18
      #
      # @param [Leafy::Metrics::Registry] where to register the metrics
      # @param [String] basename
      def self.register_thread_state_gauges( registry, name )
        registry.register_metric( name, com.codahale.metrics.jvm.ThreadStatesGaugeSet.new )
      end

      # TODO not sure about the FileDescriptorRatioGauge and ClassLoadingGaugeSet
    end
  end
end
