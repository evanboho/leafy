require 'leafy/logger/factory'

module Leafy
  module Rack
    # Sets our Leafy logger as the rack logger to be used by other middleware / frameworks down
    # the line. If you want your middleware to use this logger, we require that this runs first.
    class Logger

      def initialize(app, logger_name)
        @app = app
        @logger = Leafy::Logger::Factory.get_logger(logger_name)
      end

      def call(env)
        env['rack.logger'] = @logger
        @app.call(env)
      end
    end
  end
end
