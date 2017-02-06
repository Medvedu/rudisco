#!/usr/bin/env ruby
# encoding: utf-8

require File.join(__dir__, '..', 'sources', 'rudisco')

Rudisco::CLI.start ARGV
