require 'leafy/logger'
module Leafy
  module Logger
    module AppenderFactory

      def threshold
        super.to_s
      end

      def threshold= t
        super Java::ChQosLogbackClassic::Level.const_get( t.to_s.upcase )
      end

      def attributes
        self.methods.select { |m| m.to_s =~ /^set_/ }.collect { |m| m.to_s.sub( /^set_/, '' ) }
      end

      module ClassMethods
        def new( *args, &block )
          if block
            f = new( *args )
            f.instance_eval( &block )
            f
          else
            super
          end
        end
      end
    end

    class Java::IoDropwizardLogging::FileAppenderFactory

      include AppenderFactory
      extend AppenderFactory::ClassMethods

      def initialize( file = nil )
        super()
        if file
          self.current_log_filename = file
          self.archive = false
        end
      end
    end
    FileAppenderFactory = Java::IoDropwizardLogging::FileAppenderFactory

    class Java::IoDropwizardLogging::ConsoleAppenderFactory

      include AppenderFactory
      extend AppenderFactory::ClassMethods

      alias :_target :target
      def target( arg = nil )
        if arg
          self.target = arg
        else
          _target.to_s
        end
      end

      alias :_target= :target=
      def target= t
        self._target = Java::IoDropwizardLogging::ConsoleAppenderFactory::ConsoleStream.value_of( t.to_s.upcase )
      end
    end
    ConsoleAppenderFactory = Java::IoDropwizardLogging::ConsoleAppenderFactory


    class Java::IoDropwizardLogging::SyslogAppenderFactory

      include AppenderFactory
      extend AppenderFactory::ClassMethods

      def self.all_facilities
        Java::IoDropwizardLogging::SyslogAppenderFactory::Facility.values.collect { |f| f.to_s }
      end

      alias :_facility :facility
      def facility
        _facility.to_s
      end

      alias :_facility= :facility=
      def facility= t
        self._facility = Java::IoDropwizardLogging::SyslogAppenderFactory::Facility.value_of( t.to_s.upcase )
      end
    end
    SyslogAppenderFactory = Java::IoDropwizardLogging::SyslogAppenderFactory
  end
end
