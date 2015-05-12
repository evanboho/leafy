require_relative 'setup'
require 'leafy/rack/logger'
require 'logger'

describe Leafy::Rack::Logger do
  let(:logger) { instance_double(::Logger) }
  let(:logger_name) { 'some logger' }
  let(:app) { double(call: nil) }
  subject(:middleware) { described_class.new(app, logger_name) }

  before { allow(Leafy::Logger::Factory).to receive(:get_logger).and_return(logger) }

  describe '#call' do
    let(:env) { { } }
    it 'should set the logger' do
      middleware.call(env)
      expect(env['rack.logger']).to eq logger
    end
  end
end
