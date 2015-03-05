require 'leafy/logger'
require 'leafy/logger/appender_factories'

module Leafy
  module Logger
    class Factory

      def self.get_logger( name )
        org.slf4j.LoggerFactory.get_logger name
      end

      def self.bootstrap
        Java::IoDropwizardLogging::LoggingFactory.bootstrap
      end

      def initialize
        @factory = Java::IoDropwizardLogging::LoggingFactory.new
      end

      def level args = nil
        if args
          self.level = args
        else
          @factory.level.to_s
        end
      end

      def level= level
        l = level.to_s.upcase
        @factory.level = Java::ChQosLogbackClassic::Level.const_get( l )
        reconfigure
      end

      def appenders( *args )
        if args.size > 0
          self.appenders = args
        else
          @factory.appenders.to_a
        end
      end

      def appenders= args
        @factory.appenders = args
        reconfigure
      end

      def loggers( map = nil )
        if map
          self.loggers = map
        else
          Hash[ @factory.loggers.collect {|k,v| [k, v.to_s ] } ]
        end
      end

      def []=( name, level )
        m = @factory.loggers.to_hash
        m[ name ] = level
        self.loggers = m
      end

      def loggers= map
        m = {}
        map.each { |k,v| m[k] = Java::ChQosLogbackClassic::Level.const_get( v.to_s.upcase ) }
        @factory.loggers = m
        reconfigure
      end

      def configure( metrics, name )
        @metrics = metrics
        @name = name
        reconfigure
      end

      def reconfigure
        @factory.configure( @metrics.metrics, @name ) if @metrics
      end

      def stop
        @factory.stop
      end
    end
  end
end
