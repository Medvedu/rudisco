# encoding: utf-8
# frozen_string_literal: true
require_relative '../lib/rudisco'

path_to_load = File.join(__dir__, '..', 'tmp')

sample = Rudisco::Gem.exclude(source_code_url: '').first
sample.action(:open_sources)
      .action(:git_clone, path: path_to_load)

sample2 = Rudisco::Gem.limit(2)
sample2.action(:download, path: path_to_load)
