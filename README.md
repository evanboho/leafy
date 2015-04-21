# Leafy

[![Join the chat at https://gitter.im/lookout/leafy](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/lookout/leafy?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/lookout/leafy.svg?branch=master)](https://travis-ci.org/lookout/leafy)

The green way to build Ruby-based web services


## Goals

The goal of Leafy is to provide an out-of-the-box set of best practices and tools for building [JRuby](http://jruby.org)-based web services. In its initial form, it is based largely on [Dropwizard](http://dropwizard.io) underneath but this is not a long-term guarantee and may change in the future. As such the APIs exposed by Leafy should be stable regardless of what is "under the hood."

Leafy should provide standard means of:

 * Tracking metrics
 * Logging
 * Health checks
 * Exposing operations-friendly interfaces

## how to release all the gems

adjust the version in

* [leafy-complete.gemspec](https://github.com/lookout/leafy/blob/master/leafy-complete.gemspec)
* [leafy-metrics/lib/leafy/metrics/version.rb](https://github.com/lookout/leafy/blob/master/leafy-metrics/lib/leafy/metrics/version.rb)
* [leafy-health/lib/leafy/health/version.rb](https://github.com/lookout/leafy/blob/master/leafy-health/lib/leafy/health/version.rb)
* [leafy-rack/lib/leafy/rack/version.rb](https://github.com/lookout/leafy/blob/master/leafy-rack/lib/leafy/rack/version.rb)
* [leafy-logger/lib/leafy/logger/version.rb](https://github.com/lookout/leafy/blob/master/leafy-logger/lib/leafy/logger/version.rb)

now build and push each gem
