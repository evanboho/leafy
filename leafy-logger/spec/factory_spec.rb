require_relative 'setup'
require 'leafy/metrics/registry'
require 'leafy/logger/factory'
require 'fileutils'

describe Leafy::Logger::Factory do

  subject do
    f = Leafy::Logger::Factory.new
    f.appenders( Leafy::Logger::FileAppenderFactory.new( log ) )
    f.configure( Leafy::Metrics::Registry.new, 'tester' )
    f
  end

  let( :log ) { File.join( File.dirname( __FILE__ ), 'test.log' ) }
  let( :yaml ) { File.join( File.dirname( __FILE__ ), 'logging.yml' ) }
  let( :logger1 ) { Leafy::Logger::Factory.get_logger 'my.app' }
  let( :logger2 ) { Leafy::Logger::Factory.get_logger 'my.db' }

  let( :factory_yaml ) { Leafy::Logger::Factory.new_from_yaml( yaml ) }
  let( :reconfigured_yaml ) do
    subject.reconfigure_from_yaml( yaml )
    subject
  end

  let( :options ) { YAML.load( File.read( yaml ) ) }
  let( :factory_options ) { Leafy::Logger::Factory.new_from_options( options ) }
  let( :reconfigured_options ) do
    subject.reconfigure_from_options( options )
    subject
  end

  before { FileUtils.rm_f log }
  after { FileUtils.rm_f log }

  it 'can set appenders' do
    expect( subject.appenders.size ).to eq 1

    subject.appenders Leafy::Logger::ConsoleAppenderFactory.new
    expect( subject.appenders.size ).to eq 1

    subject.appenders( Leafy::Logger::ConsoleAppenderFactory.new,
                       Leafy::Logger::FileAppenderFactory.new( log ) )
    expect( subject.appenders.size ).to eq 2
  end

  it 'sets the default level' do
    subject.level = 'INFO'
    expect( subject.level ).to eq 'INFO'

    subject.level 'DEBUG'    
    expect( subject.level ).to eq 'DEBUG'
  end

  it 'can set the default log level' do
    subject.level = 'INFO'

    logger1.debug 'debug1'
    logger1.info 'good'
    logger1.warn 'good'
    logger2.debug 'debug2'
    logger2.info 'good'
    logger2.warn 'good'
 
    subject.stop

    lines = File.read( log ).split( /\n/ )

    expect( lines.size ).to eq 4
    lines.each do |line|
      expect( line ).to match /INFO|WARN/
      expect( line ).to match /good/
    end
  end

  it 'can set a specific log level' do
    expect( subject.loggers ).to eq Hash[]

    subject[ 'my.app' ] = 'WARN'

    expect( subject.loggers ).to eq Hash[ 'my.app' => 'WARN' ]

    logger1.debug 'debug1'
    logger1.info 'info1'
    logger1.warn 'good'
    logger2.debug 'debug2'
    logger2.info 'good'
    logger2.warn 'good'

    subject.stop

    lines = File.read( log ).split( /\n/ )

    expect( lines.size ).to eq 3
    lines.each do |line|
      expect( line ).to match /INFO|WARN/
      expect( line ).to match /good/
    end
  end

  it 'can set a specific log level' do
    expect( subject.loggers ).to eq Hash[]

    subject.loggers( 'my' => 'WARN' )

    expect( subject.loggers ).to eq Hash[ 'my' => 'WARN' ]

    logger1.debug 'debug1'
    logger1.info 'info1'
    logger1.warn 'good'
    logger2.debug 'debug2'
    logger2.info 'info2'
    logger2.warn 'good'

    subject.stop

    lines = File.read( log ).split( /\n/ )

    expect( lines.size ).to eq 2
    lines.each do |line|
      expect( line ).to match /WARN/
      expect( line ).to match /good/
    end

  end

  it 'fails on missing yaml configuration' do
    expect {Leafy::Logger::Factory.new_from_yaml( yaml + '.gone' ) }.to raise_error( Exception )
  end

  it 'fails reconfigure on missing yaml configuration' do
    expect {subject.reconfigure_from_yaml( yaml + '.gone' ) }.to raise_error( Exception )
  end

  [ :factory_yaml, :reconfigured_yaml ].each do |method|
    it "can use a yaml configuration - #{method}" do
      f = send( method )
      expect( f.level ).to eq 'ERROR'
      expect( f.loggers ).to eq 'com.example.app' => 'DEBUG'
      expect( f.appenders.size ).to eq 3
      # console
      expect( f.appenders[0].threshold ).to eq 'DEBUG'
      expect( f.appenders[0].target ).to eq 'STDERR'
      # file
      expect( f.appenders[1].threshold ).to eq 'INFO'
      expect( f.appenders[1].current_log_filename ).to eq './logs/example.log'
      expect( f.appenders[1].archived_log_filename_pattern ).to eq './logs/example-%d.log.gz'
      expect( f.appenders[1].archived_file_count ).to eq 12
      # syslog
      expect( f.appenders[2].host ).to eq '127.0.0.1'
      expect( f.appenders[2].port ).to eq 123
      expect( f.appenders[2].facility ).to eq 'KERN'
    end
  end

  [ :factory_options, :reconfigured_options ].each do |method|
    it 'can use a hash configuration' do
      f = send( method )
      expect( f.level ).to eq 'ERROR'
      expect( f.loggers ).to eq 'com.example.app' => 'DEBUG'
      expect( f.appenders.size ).to eq 3
      # console
      expect( f.appenders[0].threshold ).to eq 'DEBUG'
      expect( f.appenders[0].target ).to eq 'STDERR'
      # file
      expect( f.appenders[1].threshold ).to eq 'INFO'
      expect( f.appenders[1].current_log_filename ).to eq './logs/example.log'
      expect( f.appenders[1].archived_log_filename_pattern ).to eq './logs/example-%d.log.gz'
      expect( f.appenders[1].archived_file_count ).to eq 12
      # syslog
      expect( f.appenders[2].host ).to eq '127.0.0.1'
      expect( f.appenders[2].port ).to eq 123
      expect( f.appenders[2].facility ).to eq 'KERN'
    end
  end
end
