require_relative 'setup'

require 'leafy/instrumented/basic_instrumented'

describe Leafy::Instrumented::BasicInstrumented do

  subject { Leafy::Instrumented::BasicInstrumented.new( registry, "name" ) }
 
  let( :registry ) { Leafy::Metrics::Registry.new }

  let( :app ) do
    Proc.new() do
      sleep 0.1
      [ 200, nil, "" ]
    end
  end

  it 'collects metrics for a call' do
    _, _, _ = subject.call do
      app.call
    end
    expect( registry.metrics.meters.keys ).to eq [ 'name.responseCodes.other' ] 
    expect( registry.metrics.meters.values.collect { |a| a.count } ).to eq [ 1 ]
    expect( registry.metrics.meters.values.first.mean_rate ).to be > 5.0
  end
end
