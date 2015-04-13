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
