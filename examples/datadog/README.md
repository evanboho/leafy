# datadog gauge with tags example

## setup

execute with jruby

    # installs all the gems
    bundle install
    # install all the jars and creates Jars.lock for the runtime
    rmvn initialize

## run example

needs the datadog agent running and then

    bundle exec ruby lib/metrics.rb
