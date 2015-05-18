require_relative 'setup'
require 'leafy/logger/proxy_logger'
require 'logger'

describe Leafy::Logger::ProxyLogger do
  subject(:proxy) { described_class.new(logger) }
  let(:logger) { instance_double(Logger, debug: debug_result, error: error_result) }
  let(:debug_result) { 'debug result' }
  let(:error_result) { 'error result' }

  describe '#method_missing' do
    it 'should call the logger when given a method that exists' do
      expect(proxy.debug).to eq debug_result
    end

    it 'should raise a NameError when given a method that does not exist' do
      expect { proxy.lol }.to raise_error(NameError)
    end
  end

  describe '#fatal' do
    it 'should call #error' do
      expect(proxy.fatal(:a)).to eq error_result
      expect(logger).to have_received(:error).with(:a)
    end
  end
end
