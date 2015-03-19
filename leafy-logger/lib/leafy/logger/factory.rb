require 'leafy/logger'
require 'leafy/logger/appender_factories'
require 'yaml'
require 'stringio'
require 'jruby/synchronized'

module Leafy
  module Logger
    class Factory
      include JRuby::Synchronized

      class HashSourceProvider
        include Java::IoDropwizardConfiguration::ConfigurationSourceProvider

        def initialize( config )
          @config = config
        end

        def open(path)
          StringIO.new( @config.to_yaml ).to_inputstream
        end
      end

      def self.get_logger( name )
        org.slf4j.LoggerFactory.get_logger name
      end

      def self.bootstrap
        Java::IoDropwizardLogging::LoggingFactory.bootstrap
      end

      def self.configurator
        objectMapper = Java::IoDropwizardJackson::Jackson.newObjectMapper
        validator = javax.validation.Validation.buildDefaultValidatorFactory.validator
        Java::IoDropwizardConfiguration::ConfigurationFactory.new( Java::IoDropwizardLogging::LoggingFactory.java_class, validator, objectMapper, "" )
      end

      def self.new_from_options( options )
        new( configurator.build( HashSourceProvider.new( options ), 'dummy') )
      end

      def self.new_from_yaml( yamlfile )
        raise "no such file #{yamlfile}" unless File.exists?( yamlfile )
        new( configurator.build( java.io.File.new( yamlfile ) ) )
      end

      def initialize( factory = nil )
        @factory = factory || Java::IoDropwizardLogging::LoggingFactory.new
      end

      def reconfigure_from_options( options )
        do_reconfigure( self.class.configurator.build( HashSourceProvider.new( options ), 'dummy') )
      end

      def reconfigure_from_yaml( yamlfile )
        raise "no such file #{yamlfile}" unless File.exists?( yamlfile )
        do_reconfigure( self.class.configurator.build( java.io.File.new( yamlfile ) ) )
      end

      def do_reconfigure( factory )
        @factory.stop
        @factory = factory
        reconfigure
      end
      private :do_reconfigure

      def level args = nil
        if args
          self.level = args
        else
          @factory.level.to_s
        end
      end

      def level_set level
        l = level.to_s.upcase
        @factory.level = Java::ChQosLogbackClassic::Level.const_get( l )
      end
      private :level_set

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

      def loggers_set map
        m = {}
        map.each { |k,v| m[k] = Java::ChQosLogbackClassic::Level.const_get( v.to_s.upcase ) }
        @factory.loggers = m
      end
      private :loggers_set

      def loggers= map
        loggers_set( map )
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
