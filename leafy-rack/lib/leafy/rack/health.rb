require 'leafy/rack'
require 'leafy/json/health_writer'
require 'json' unless defined? :JSON

module Leafy
  module Rack
    class Health

      def self.hostinfo
        @info ||= {}
      end

      def self.response( health, env )
        checks = health.run_health_checks
        if @info
          data = { 'host' => @info, 'checks' => checks.to_hash }
        else
          data = checks
        end
        is_healthy = checks.values.all? { |r| r.healthy? }
        json = if env[ 'QUERY_STRING' ] == 'pretty'
                 JSON.pretty_generate( data.to_hash )
               else
                 # to use data.to_hash.to_json did produce
                 # a different json structure on some
                 # rack setup
                 JSON.generate( data.to_hash )
               end
        [
         is_healthy ? 200 : 503, 
         { 'Content-Type' => 'application/json',
           'Cache-Control' => 'must-revalidate,no-cache,no-store' }, 
         [ json ]
        ]
      end

      def initialize(app, registry, path = '/health')
        @app = app
        @path = path
        @registry = registry
      end
      
      def call(env)
        if env['PATH_INFO'] == @path
          Health.response( @registry.health, env )
        else
          @app.call( env )
        end
      end
    end
  end
end
