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

      def initialize( &block )
        super
        instance_eval( &block ) if block
      end
    end

    class FileAppenderFactory < Java::IoDropwizardLogging::FileAppenderFactory

      include AppenderFactory

      alias :init :initialize
      def initialize( file = nil, &block )
        init( &block )
        if file
          self.current_log_filename = file
          self.archive = false
        end
      end
    end

    class ConsoleAppenderFactory < Java::IoDropwizardLogging::ConsoleAppenderFactory

      include AppenderFactory

      def target( arg = nil )
        if arg
          self.target = arg
        else
          super().to_s
        end
      end

      def target= t
        super Java::IoDropwizardLogging::ConsoleAppenderFactory::ConsoleStream.value_of( t.to_s.upcase )
      end
    end

    class SyslogAppenderFactory < Java::IoDropwizardLogging::SyslogAppenderFactory

      include AppenderFactory

      def self.all_facilities
        Java::IoDropwizardLogging::SyslogAppenderFactory::Facility.values.collect { |f| f.to_s }
      end

      def facility
        super.to_s
      end

      def facility= t
        super Java::IoDropwizardLogging::SyslogAppenderFactory::Facility.value_of( t.to_s.upcase )
      end
    end
  end
end
