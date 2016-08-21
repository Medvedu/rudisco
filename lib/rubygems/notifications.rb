# encoding: utf-8

# no-doc
module RubyGem
  # no-doc
  module Msg
    #
    #
    #
    def self.print(*msgs)
      $stdout << msgs.join if Settings.get[:verbose]
    end

    #
    #
    #
    def self.puts(*msgs)
      $stdout << msgs.join("\n") << "\n" if Settings.get[:verbose]
    end

    #
    #
    #
    # def self.warning(msg, &block)
    #   raise StandartError, 'block missed! ' unless block_given?
    #   if block_given?
    #     $stdout << msgs.join("\n") << "\n" if Settings.get[:verbose] && (block.call == true)
    #   end
    # end
  end # module Notification
end # module RubyGem
