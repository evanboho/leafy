# Leafy-Logger

## installation

via rubygems
```
gem install leafy-logger
```
or add to your Gemfile
```
gem 'leafy-logger
```

installing the gem also takes care of the jar dependencies with jruby-1.7.16+

## usage

default configuration
```
require 'leafy/logger/factory'
require 'leafy/metrics/registry'

f = Leafy::Logger::Factory.new
f.configure( Leafy::Metrics::Registry.new, 'application' )

l = Leafy::Logger::Factory.get_logger 'my.app'
```

the configure will setup the (default) appenders and register the metrics.

there are more configurations for the logger Factory
```
require 'leafy/logger/appender_factories'

f.level = 'INFO'
f.loggers 'my.app' => 'WARN', 'my' => 'DEBUG'
f.appenders( Leafy::Logger::ConsoleAppenderFactory.new,
             Leafy::Logger::FileAppenderFactory.new('log/my.log' ) )
f[ 'my.db' ] = 'INFO'
```

after the logger factory was configured once, any change of the log levels will result in a reconfiguration.

## appender factories

all appender factories have common set of attributes:
```
appender = Leafy::Logger::ConsoleAppenderFactory.new do
  # :off, :trace, :debug, :info, :warn, :error, :all
  self.threshold = :debug # default :all
  self.log_format = "%-5p [%d{ISO8601,UTC}] %c: %m%n%ex"
  self.queue_size = 1024 # default 256
  # means nothing gets discarded
  self.discarding_threshold = 0 # default -1
end
```

### console appender factory

```
appender = Leafy::Logger::ConsoleAppenderFactory.new do
  self.target 'STDOUT' # default is 'STDERR'
end
```

### syslog appender factory

```
appender = Leafy::Logger::SyslogAppenderFactory.new do
  self.host = '127.0.0.1' # default localhost
  self.port = 514 # default 514
  self.include_stack_trace = false # default true
  # see Leafy::Logger::SyslogAppenderFactory.all_facilities
  self.facility = :auth # default :local0
  self.stack_trace_prefix = '__' # default '!'
end
```

### file appender factory

without archived files

```
appender = Leafy::Logger::SyslogAppenderFactory.new( 'logs/app.log' )
```

or

```
appender = Leafy::Logger::SyslogAppenderFactory.new do
  self.current_log_filename = 'logs/app.log'
end
```

with archived files

```
appender = Leafy::Logger::SyslogAppenderFactory.new do
  self.current_log_filename = 'logs/app.log'
  self.archive = true # default true
  # files ending with .gz or .zip will packed respectively
  self.archived_log_filename_pattern = 'logs/app-%d.log'
  self.archived_file_count = 10 # default 5
end
```

# using configurations

a yaml file or an options hash can be used to configure the logger factory. once you have a logger factory you can reconfigure it with a yaml-file or options hash at runtime.

## build logger factory from yaml file

having a yaml file like (config/logging.yaml)

```
level: ERROR
loggers:
  com.example.app: DEBUG
  com.example.db: INFO
appenders:
  - type: console
    threshold: DEBUG
    target: STDERR
  - type: file
    threshold: INFO
    currentLogFilename: ./logs/example.log
    archivedLogFilenamePattern: ./logs/example-%d.log.gz
    archivedFileCount: 12
  - type: syslog
    host: 127.0.0.1
    port: 123
    facility: KERN
```
can be used to build ```LoggerFactory``` directly from this yaml file:

```
factory = Leafy::Logger::Factory.new_from_yaml( 'config/logging.yaml' )
```

having the same config as ```Hash``` can be used as well

```
options = YAML.load( File.read( 'config/logging.yaml' ) )
factory = Leafy::Logger::Factory.new_from_options( options )
```

## reconfigure logger factory at runtime

```
factory.reconfigure_from_yaml( 'config/logging.yaml' )
```

or

```
factory.reconfigure_from_options( options )
```

## developement

get all the gems and jars in place

    gem install jar-dependencies --development
	bundle install

please make sure you are using jar-dependencies >= 0.1.8 !

for running all specs

	rake

or a single one

    rspec spec/reporter_spec.rb
