require_relative 'setup'
require 'leafy/metrics/registry'
require 'leafy/metrics/jvm_metrics'

describe Leafy::Metrics::JvmMetrics do

  let(:registry) { Leafy::Metrics::Registry.new }

  describe "register_thread_state_gauges" do
  
    before do
      Leafy::Metrics::JvmMetrics.register_thread_state_gauges( registry, 'test' )
    end

    it 'registers gauges' do
      
      expect( registry.metrics.names.to_a ).to include( *["test.blocked.count", "test.count", "test.daemon.count", "test.deadlock.count", "test.deadlocks", "test.new.count", "test.runnable.count", "test.terminated.count", "test.timed_waiting.count", "test.waiting.count"] )
    end

    it 'follows changes in thread counts' do
      
      total = registry.metrics.gauges['test.count'].value
      
      t = Thread.new do
        Thread.current[:running] = true
        while( Thread.current[:running] ) do
          sleep 0.1
        end
      end

      expect( registry.metrics.gauges['test.count'].value ).to eq total + 1
      
      t[:running] = false
      sleep 0.1
      t.join

      expect( registry.metrics.gauges['test.count'].value ).to eq total
    end
  end

  describe "register_memory_usage_gauges" do
  
    before do
      Leafy::Metrics::JvmMetrics.register_memory_usage_gauges( registry, 'test' )
    end

    it 'registers gauges' do
      
      expect( registry.metrics.names.to_a ).to include( *["test.heap.committed", "test.heap.init", "test.heap.max", "test.heap.usage", "test.heap.used", "test.non-heap.committed", "test.non-heap.init", "test.non-heap.max", "test.non-heap.usage", "test.non-heap.used", "test.total.committed", "test.total.init", "test.total.max", "test.total.used"] )
      
    end
  end

  describe "register_buffer_pool_metrics" do
  
    before do
      Leafy::Metrics::JvmMetrics.register_buffer_pool_metrics( registry, 'test' )
    end

    it 'registers metrics' do
      
      expect( registry.metrics.names.to_a ).to include( *["test.direct.capacity", "test.direct.count", "test.direct.used", "test.mapped.capacity", "test.mapped.count", "test.mapped.used"] )
      
    end
  end

  describe "register_garbage_collector_metrics" do
  
    before do
      Leafy::Metrics::JvmMetrics.register_garbage_collector_metrics( registry, 'test' )
    end

    it 'registers metrics' do
      
      expect( registry.metrics.names.to_a ).to include( *["test.PS-MarkSweep.count", "test.PS-MarkSweep.time", "test.PS-Scavenge.count", "test.PS-Scavenge.time"] )
      
    end
  end
end
