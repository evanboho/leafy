require 'leafy/metrics'

module Leafy
  module Metrics
    module JRubyMetrics

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
