# encoding: utf-8
# frozen_string_literal: true
module Rudisco
  module RubyGemsScanner # no-doc
    ##
    # Scans rubygems.org for new gems. Also marks gems as outdated when
    # new gem version is out.
    #
    # To load an actual information for newest gems use #deep_scanning.

    def surface_scanning
      _surface_scanning
    end

    ##
    # Long-term task. Updates database with an actual information. Multithread.
    #
    # Note: speed limited by rubygems.org.
    #
    #   Can be increased with advanced concurrent processes setup for
    #   sqlite database.
    #
    #   However, this is slow since rubygems.org allowing certain requests
    #   per second count.
    #
    # @param [Proc<Integer>] callback
    #   Returns count of updated gems, optional.

    def deep_scanning(&callback)
      _deep_scanning &callback
    end

    ##
    # Updates cortege(s).
    #
    # Used to get latest information about gem(s) total downloads
    # count and so on.
    #
    # @param [Rudisco::Gem, Array<Rudisco::Gem>] corteges

    def corteges_scanning(corteges)
      rubygems_manage_corteges Array(corteges)
    end

    private

    def _surface_scanning # no-doc
      rubygems =
        begin
          tmp_file = Tempfile.new 'gems.tmp'

          system "gem list --remote > #{tmp_file.path}"
          rubygems = CSV.open tmp_file.path
          rubygems = rubygems.map { |r| r.join.delete('()').split }
          tmp_file.unlink

          rubygems
        end
      sqlite_gems = select_hash :name, :version

      ## ADD NEW GEMS TO DATABASE
      db.transaction do
        new_gems = rubygems.select { |gem| sqlite_gems[gem[0]].nil? }

        new_gems.each do |gem|
          insert name: gem[0], version: gem[1]
        end
      end

      ## UPDATE RECORDS IF NEED
      db.transaction do
        update_gems = rubygems.reject { |gem| sqlite_gems[gem[0]].nil? }
                              .select { |gem| sqlite_gems[gem[0]] != gem[1] }

        update_gems.each do |gem|
          cortege = where(:name => gem[0]).first
          next if cortege[:version] > gem[1] # skip downgraded gems

          cortege[:version] = gem[1]
          cortege[:need_update] = true
          cortege.save
        end
      end
    end

    def _deep_scanning(&callback) # no-doc
      _surface_scanning # todo this call should be optional

      bunch =
        begin
          gem_update_count   = where(need_update: true).count
          threads_count      = gem_update_count > 105 ? 35 : 1
          bunch_sub_arr_size = gem_update_count / threads_count + 1

          bunch_tmp =
            Array.new(threads_count) do |i|
              self.where(need_update: true)
                  .order(:id)
                  .limit(bunch_sub_arr_size).offset(i * bunch_sub_arr_size)
            end

          bunch_tmp
        end # bunch = [ [], [], [], [], ... [] ]

      threads = []
      bunch.count.times do |i|
        threads << Thread.new(bunch[i], callback) do |sub_array, callback_proc|
          sub_array.each_slice(20) do |gems|
            db.transaction { rubygems_manage_corteges gems }
            callback_proc.call gems.count unless callback_proc.nil?
          end
        end
       end
      threads.each &:join
    end

    # @param [String] name
    #   Gem name.
    #
    # @return [Nil, String]
    #   Returns +nil+ when rubygems.org not responded, otherwise it
    #   returns encoded json as a string.

    def send_request_to_rubygems(name)
      for try_count in 1...25 do
        begin
          sleep try_count * 0.35
          url = URI.parse "https://rubygems.org/api/v1/gems/#{name}.json"
          response = Net::HTTP.get_response(url)

          return response.body if response.is_a? Net::HTTPSuccess
        rescue Errno::ECONNRESET, Net::OpenTimeout
          next
        end
      end

      return nil
    end

    ##
    # Updates +cortege+ with a data from +hsh+.
    #
    # @param [Rudisco::Gem] cortege
    #
    # @param [Hash] hsh

    def update_cortege(cortege, hsh)
      cortege[:description] = hsh["info"].to_s
      cortege[:authors]     = hsh["authors"].to_s
      cortege[:license]     = Array(hsh["licenses"]).join
      cortege[:sha]         = hsh["sha"].to_s

      # "$ gem -list" and rubygems.org/api can send different information about
      # last version for a gem. To prevent collision this code not downgrades
      # gem version.
      #
      # In other words "$ gem list" have higher priority under rubygems.org/api
      if hsh["version"].to_s > cortege[:version]
        cortege[:version] = hsh["version"].to_s
      end

      cortege[:source_code_url]   = hsh["source_code_uri"].to_s
      cortege[:project_url]       = hsh["project_uri"].to_s
      cortege[:gem_url]           = hsh["gem_uri"].to_s
      cortege[:wiki_url]          = hsh["wiki_uri"].to_s
      cortege[:documentation_url] = hsh["documentation_uri"].to_s
      cortege[:mailing_list_url]  = hsh["mailing_list_uri"].to_s
      cortege[:bug_tracker_url]   = hsh["bug_tracker_uri"].to_s

      cortege[:total_downloads]   = hsh["downloads"].to_i
      cortege[:version_downloads] = hsh["version_downloads"].to_i

      cortege[:need_update] = false
    end

    # @param [Array<Rudisco::Gem>] corteges

    def rubygems_manage_corteges(corteges)
      corteges.each do |cortege|
        response = send_request_to_rubygems cortege[:name]

        if response.nil?
          next
        elsif response =~ /could not be found/
          cortege.destroy # gem was deleted from rubygems.org
        else
          data = JSON.parse response
          update_cortege cortege, data

          cortege.save
        end
      end
    end
  end # module RubyGemsScanner
end # module Rudisco
