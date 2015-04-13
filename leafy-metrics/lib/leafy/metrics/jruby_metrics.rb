require 'leafy/metrics'

module Leafy
  module Metrics
    module JRubyMetrics

      # registers a few thread gauges under the given basename: total.com, executing.count and sleeping.count
      #
      # @param [Leafy::Metrics::Registry] where to register the metrics
      # @param [String] basename
      def self.register_ruby_thread_state_gauges( registry, name )
        registry.register_gauge( name + '.total.count' ) do
          Thread.list.size
        end

        registry.register_gauge( name + '.executing.count' ) do
          Thread.list.select { |t| t.status == 'run' }.size
        end

        registry.register_gauge( name + '.sleeping.count' ) do
          Thread.list.select { |t| t.status == 'sleep' }.size
        end
      end
    end
  end
end
