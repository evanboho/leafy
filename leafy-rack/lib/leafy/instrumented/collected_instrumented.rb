require 'leafy/instrumented/basic_instrumented'

module Leafy
  module Instrumented
    class CollectedInstrumented < BasicInstrumented

      INFO = 1;
      SUCCESS = 2;
      REDIRECT = 3;
      CLIENT = 4;
      SERVER = 5;

      # creates the some metrics for status code 2xx, 3xx, 4xx and 5xx. all none registered status codes are marked on the meter named 'other'.
      #
      # @param [Leafy::Metrics::Registry] the registry on which register the metrics
      # @param [String] name basename of the metrics
      def initialize( registry, name )
        super( registry, name,
               { SUCCESS => "#{NAME_PREFIX}.2xx",
                 REDIRECT => "#{NAME_PREFIX}.3xx",
                 CLIENT => "#{NAME_PREFIX}.4xx",
                 SERVER => "#{NAME_PREFIX}.5xx" } )
      end

      def mark_meter_for_status_code( status )
        super( status/ 100 )
      end
    end
  end
end
