require 'leafy/metrics'

module Leafy
  module Metrics
    module JvmMetrics
      def self.register_buffer_pool_metrics( registry, name )
        # use the same MBenServer as JRuby does
        registry.register_metric( name, com.codahale.metrics.jvm.BufferPoolMetricSet.new( java.lang.management.ManagementFactory.getPlatformMBeanServer ) )
      end

      def self.register_memory_usage_gauges( registry, name )
        registry.register_metric( name, com.codahale.metrics.jvm.MemoryUsageGaugeSet.new )
      end

      def self.register_garbage_collector_metrics( registry, name )
        registry.register_metric( name, com.codahale.metrics.jvm.GarbageCollectorMetricSet.new )
      end

      def self.register_thread_state_gauges( registry, name )
        registry.register_metric( name, com.codahale.metrics.jvm.ThreadStatesGaugeSet.new )
      end

      # TODO not sure about the FileDescriptorRatioGauge and ClassLoadingGaugeSet
    end
  end
end
