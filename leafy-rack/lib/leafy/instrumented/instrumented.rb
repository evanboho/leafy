require 'leafy/instrumented/basic_instrumented'

module Leafy
  module Instrumented
    class Instrumented < BasicInstrumented

      OK = 200;
      CREATED = 201;
      NO_CONTENT = 204;
      RESET_CONTENT = 205;
      BAD_REQUEST = 400;
      NOT_FOUND = 404;
      SERVER_ERROR = 500;

      # creates the some metrics for status code 200, 201, 204, 205, 400, 404 and 500. all none registered status codes are marked on the meter named 'other'. further the request time get measured and the active request counter is maintained.
      #
      # @param [Leafy::Metrics::Registry] the registry on which register the metrics
      # @param [String] name basename of the metrics
      def initialize( registry, name )
        super( registry, name,
               { OK => "#{NAME_PREFIX}.ok",
                 CREATED => "#{NAME_PREFIX}.created",
                 NO_CONTENT => "#{NAME_PREFIX}.noContent",
                 RESET_CONTENT => "#{NAME_PREFIX}.resetContent",
                 BAD_REQUEST => "#{NAME_PREFIX}.badRequest",
                 NOT_FOUND => "#{NAME_PREFIX}.notFound",
                 SERVER_ERROR => "#{NAME_PREFIX}.serverError" } )
        @active = registry.register_counter( "#{name}.active_requests" )
        @timer = registry.register_timer( "#{name}.requests" )
      end

      # basically wraps a rack middleware call. mesures the request time and
      # keeps an active request counter.
      def call( &block )
        raise "block needed" unless block_given?
        @active.inc

        @timer.time do

          super

        end
      ensure
        @active.dec
      end

      def mark_meter_for_status_code( status )
        metric = @meters_by_status_code[ status ] || @other
        metric.mark
      end
    end
  end
end
