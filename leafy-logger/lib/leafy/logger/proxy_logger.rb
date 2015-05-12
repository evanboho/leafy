module Leafy
  module Logger
    class ProxyLogger
      def initialize(logger)
        @logger = logger
      end

      def method_missing(sym, *args, &block)
        if @logger.respond_to?(sym)
          @logger.send(sym, *args)
        else
          super
        end
      end

      def respond_to?(sym, include_private = false)
        @logger.respond_to?(sym, include_private)
      end

      # slf4j does not include the fatal level
      def fatal(*args)
        error(*args)
      end

      # Provided for compatibility with the stdlib Logger interface. Not used, since the logger
      # that we're proxying has a much better formatter! (Right?)
      attr_accessor :formatter
    end
  end
end
