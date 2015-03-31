require 'leafy/instrumented/basic_instrumented'

module Leafy
  module Instrumented
    class CollectedInstrumented < BasicInstrumented

      INFO = 1;
      SUCCESS = 2;
      REDIRECT = 3;
      CLIENT = 4;
      SERVER = 5;

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
