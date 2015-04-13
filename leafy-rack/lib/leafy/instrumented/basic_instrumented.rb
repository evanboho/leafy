# basically a meter on all requests. but can customized by a status-code to meter map. see constructor.
module Leafy
  module Instrumented
    class BasicInstrumented

      NAME_PREFIX = "responseCodes"

      # creates the metrics. all none registered status codes are marked on the meter named 'other'
      #
      # @param [Leafy::Metrics::Registry] the registry on which register the metrics
      # @param [String] name basename of the metrics
      # @param [Hash] map of status code [Integer] to meter-name [String]. for each code there will be a meter.
      def initialize( registry, name, meter_names_by_status_code = {} )
        @meters_by_status_code = java.util.concurrent.ConcurrentHashMap.new
        meter_names_by_status_code.each do |k,v|
          @meters_by_status_code[ k ] = registry.register_meter( "#{name}.#{v}" )
        end
        @other = registry.register_meter( "#{name}.#{NAME_PREFIX}.other" )
      end

      # basically wraps a rack middleware call
      def call( &block )
        raise "block needed" unless block_given?
        result = block.call
        mark_meter_for_status_code result[0]
        result
      end

      def mark_meter_for_status_code( status )
        metric = @meters_by_status_code[ status ] || @other
        metric.mark
      end
    end
  end
end
