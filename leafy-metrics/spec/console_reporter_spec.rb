require_relative 'setup'
require 'leafy/metrics/console_reporter'

describe Leafy::Metrics::ConsoleReporter do

  subject { Leafy::Metrics::ConsoleReporter }

  let( :metrics ) { Leafy::Metrics::Registry.new }
  let( :requests ) { metrics.register_meter( "requests" ) }

  it 'run reporter with defaults' do
    old_out = java.lang.System.out
    bytes = StringIO.new
    java.lang.System.out = java.io.PrintStream.new( bytes.to_outputstream )
    begin
      reporter = metrics.reporter_builder( subject ).build
      requests.mark
      reporter.start( 10, Leafy::Metrics::Reporter::MILLISECONDS )
      sleep 0.02
      reporter.stop
      result = bytes.string.gsub( /\n/m, '')
      expect( result ).to match /count = 1/
      expect( result ).to match /second/
    ensure
      java.lang.System.out = old_out
      reporter.stop if reporter
    end
  end

  it 'run reporter via builder config' do
    bytes = StringIO.new
    begin
      reporter = metrics.reporter_builder( subject )
        .convert_rates_to( Leafy::Metrics::Reporter::MILLISECONDS )
        .convert_durations_to( Leafy::Metrics::Reporter::MILLISECONDS )
        .output_to( bytes )
        .build

      requests.mark
      reporter.start( 10, Leafy::Metrics::Reporter::MILLISECONDS )
      sleep 0.02
      reporter.stop
      result = bytes.string.gsub( /\n/m, '')
      expect( result ).to match /count = 1/
      expect( result ).to match /millisecond/
    ensure
      reporter.stop if reporter
    end
  end

  it 'run reporter via block config' do
    bytes = StringIO.new
    begin
      reporter = metrics.reporter_builder( subject ) do
        convert_rates_to( Leafy::Metrics::Reporter::MILLISECONDS )
        convert_durations_to( Leafy::Metrics::Reporter::MILLISECONDS )
        output_to( bytes )
      end.build

      requests.mark
      reporter.start( 10, Leafy::Metrics::Reporter::MILLISECONDS )
      sleep 0.02
      reporter.stop
      result = bytes.string.gsub( /\n/m, '')
      expect( result ).to match /count = 1/
      expect( result ).to match /millisecond/
    ensure
      reporter.stop if reporter
    end
  end

end
