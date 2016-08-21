# encoding: utf-8

# no-doc
module RubyGem
  # no-doc
  module Helpers
    #
    #
    #
    def file_exists_less_than_day?(file)
      File.exist?(file) && ((Time.now - File.ctime(file)) / 86_400).floor < 1
    end
  end # module Helpers
end # module RubyGem
