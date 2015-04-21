require_relative 'setup'

require 'leafy/instrumented/collected_instrumented'

describe Leafy::Instrumented::CollectedInstrumented do

  subject { Leafy::Instrumented::CollectedInstrumented.new( registry, "name" ) }
 
  let( :registry ) { Leafy::Metrics::Registry.new }

  [ 201, 304, 404, 503, 123 ].each_with_index do |status, index|
    it "collects metrics for a call for status #{status}" do
      result, _, _ = subject.call do
        sleep 0.01
        [ status, nil, nil ]
      end

      expect( result ).to eq status
      
      expect( registry.metrics.meters.keys.sort ).to eq [ "name.responseCodes.2xx", "name.responseCodes.3xx", "name.responseCodes.4xx", "name.responseCodes.5xx", "name.responseCodes.other" ]

      stati = registry.metrics.meters.values.collect { |a| a.count }
      expect( stati[ index ] ).to eq 1

      expected = [0,0,0,0,0]
      expected[ index ] = 1
      expect( stati ).to eq expected

      expect( registry.metrics.meters.values.to_a[ index ].mean_rate ).to be > 50
    end
  end
end
