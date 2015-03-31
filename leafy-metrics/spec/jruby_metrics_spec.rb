require_relative 'setup'
require 'leafy/metrics/registry'
require 'leafy/metrics/jruby_metrics'

describe Leafy::Metrics::JRubyMetrics do

  subject do
    r = Leafy::Metrics::Registry.new
    Leafy::Metrics::JRubyMetrics.register_ruby_thread_state_gauges( r, 'test' )
    r
  end

  it 'registers and unregister a meter' do

    expect( subject.metrics.gauges['test.total.count'].value ).to eq 1
    expect( subject.metrics.gauges['test.executing.count'].value ).to eq 1
    expect( subject.metrics.gauges['test.sleeping.count'].value ).to eq 0

    t = Thread.new do
      Thread.current[:running] = true
      while( Thread.current[:running] ) do
        sleep 0.1
      end
    end

    expect( subject.metrics.gauges['test.total.count'].value ).to eq 2
    expect( subject.metrics.gauges['test.executing.count'].value ).to eq 1
    expect( subject.metrics.gauges['test.sleeping.count'].value ).to eq 1

    t[:running] = false
    sleep 0.1

    expect( subject.metrics.gauges['test.total.count'].value ).to eq 1
    expect( subject.metrics.gauges['test.executing.count'].value ).to eq 1
    expect( subject.metrics.gauges['test.sleeping.count'].value ).to eq 0
  end
end
