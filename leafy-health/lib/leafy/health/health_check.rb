require 'leafy/health'

# add json serialization definition
class com.codahale.metrics.health.HealthCheck::Result

  attr_writer :data

  def to_json( *args )
    # check if it is a Hash.json and treat it as json
    if message =~ /^{.+}$/
      msg = Leafy::Health::JsonString.new( message )
    else
      msg = message
    end
    { :healthy => healthy?, :message => @data || msg }.to_json( *args )
  end
end

module Leafy
  module Health
    class JsonString < String

      def to_json(*args)
        self
      end

      def as_json(*args)
        self
      end
    end

    ThreadDeadlockHealthCheck = com.codahale.metrics.health.jvm.ThreadDeadlockHealthCheck

    class HealthCheck < com.codahale.metrics.health.HealthCheck

      def initialize( &block )
        @block = block if block
      end

      # create healthy result object with given message
      #
      # param [String] optional result message, can be nil
      # return [com.codahale.metrics.health.HealthCheck::Result]
      def healthy( result = nil )
        if result.is_a? Hash
          com.codahale.metrics.health.HealthCheck::Result.healthy( result.to_json )
        else
          com.codahale.metrics.health.HealthCheck::Result.healthy( result )
        end
      end

      # create unhealthy result object with given message
      #
      # param [String] result message
      # return [com.codahale.metrics.health.HealthCheck::Result]
      def unhealthy( result )
        if result.is_a? Hash
          com.codahale.metrics.health.HealthCheck::Result.unhealthy( result.to_json )
        else
          com.codahale.metrics.health.HealthCheck::Result.unhealthy( result )
        end
      end

      def check
        case result = call
        when String
          unhealthy( result )
        when NilClass
          healthy
        when com.codahale.metrics.health.HealthCheck::Result
          result
        else
          raise 'wrong result type'
        end
      end

      def call
        if @block
          instance_eval( &@block )
        else
          'health check "call" method not implemented'
        end
      end
    end
  end
end
