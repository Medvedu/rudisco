# encoding: utf-8

# no-doc
module RubyGem
  # no-doc
  module Settings
    extend self

    #
    # config read
    #
    def get
      @config
    end

    #
    # config set
    #
    def set(params)
      @config.deep_merge! params
    end

    #
    # config set defaults
    #
    def set_defaults
      @config = {
        #
        # Disables ouput messages
        #
        verbose: false,

        #
        # download headers only when no local data available
        #
        skip_headers_download: true,

        #
        # default search works for 'name' column
        #
        search: [:name],

        #
        # database config
        #
        database: {
          adapter:  'postgresql',
          encoding: 'unicode',
          host:     'localhost',
          database: 'rubygems',
          username: 'rubygems_user',
          password: Array.new(7) { [0..9, 'a'..'z', 'A'..'Z'].sample.to_a.sample }.join,
          pool:     200
        },

        #
        # multithreading params
        #
        manager: {
          TransactionBlockSize: 20,
          ThreadsCount: 20,
          delay: 2
        }
      }
    end

    private

    attr_reader :config
  end # module Settings
end # module RubyGem
