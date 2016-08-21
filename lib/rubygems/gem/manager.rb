# encoding: utf-8

# no-doc
module RubyGem
  #
  # Manager for work with remote servers.
  #
  module Manager
    extend RubyGem::Helpers

    #
    #
    #
    def self.extended(_obj)
      rubygem = File.join(__dir__, '../' * 3, 'tmp', 'rubygems.date')
      unless File.exist?(rubygem) && Settings.get[:skip_headers_download]
        Msg.puts 'Warning! Headers are outdated' unless file_exists_less_than_day?(rubygem)
        Msg.puts 'Loading headers from rubygem@github repositories.'
        system "gem list --remote > #{rubygem}"
      end

      sRubyGem      = CSV.open(rubygem).to_set
      remoteRecords = sRubyGem.map { |r| r.join.delete('()').split }
      dbGems        = GemProxy.all.pluck(:name, :version).to_h

      new_records = remoteRecords.select { |r| dbGems[r[0]].blank? }
      GemProxy.transaction do
        new_records.each.with_index do |record, index|
          GemProxy.create(name: record[0], version: record[1])
          Msg.print("For #{index.next}/#{new_records.count} gems headers " \
                    'was added to the database.', "\r")
        end
      end
      Msg.puts "Currently in the database: #{GemProxy.count} gems."

      changed_records = remoteRecords.reject { |r| dbGems[r[0]].blank?  }
                                     .select { |r| dbGems[r[0]] != r[1] }

      # Mark records with update flag if gem version was changed on rubygems.org
      # ATTENTION! Sometimes rubygems.org sends wrong (outdated) version for gem.
      GemProxy.transaction do
        changed_records.map do |record|
          g = GemProxy.where(name: record[0]).first
          next if g.version > record[1] # !!!
          g.version = record[1]
          g.need_update = true
          g.save
        end
      end

      if (count = GemProxy.where(need_update: true).count) != 0
        Msg.puts("Warning! For #{count} gems only headers loaded. For full " \
                  'load please use update method.')
      end
    end # initialize

    private

    #
    #
    #
    def update_gems(block)
      block.each do |record|
        # hm, maybe place under 'next' operator?
        record.loaded = true
        record.need_update = false
        json = scan_gem(record.name)
        next if json.blank?

        record.created_at = Date.today if record.version != json[:version]

        # ATTENTION! Sometimes rubygems.org sends wrong (outdated) version for gem.
        record.version               = json[:version] if json[:version] > record.version

        record.description           = json[:info]
        record.authors               = json[:authors]
        record.downloads_count_all   = json[:downloads]
        record.project_uri           = json[:project_uri]
        record.license               = json[:licenses]
        record.downloads_count_last  = json[:version_downloads]
        record.sha                   = json[:sha]
        record.sourse_code_uri       = json[:source_code_uri]
        record.gem_uri               = json[:gem_uri]
      end
    end

    #
    # remote scanner with protection against empty https responses
    #
    def scan_gem(name)
      count = 0
      begin
        sleep count * 0.35
        Msg.puts 'Warning! Too much requests! Server refusing to response! ' if count > 25
        uri      = URI.parse("https://rubygems.org/api/v1/gems/#{name}.json")
        response = Net::HTTP.get_response(uri)
        count += 1
      end while response.body.empty? && (count < 50)
      return JSON.parse(response.body).symbolize_keys unless response.body.blank?
      nil
    end

    #
    #
    #
    def db_update
      if (count = GemProxy.where(loaded: false).or(GemProxy.where(need_update: true)).count).zero?
        Msg.puts '', 'Already up to date.'
        return
      end

      Msg.puts 'Update method launched. For first launch it can be long procedure.',
               'If speed is important for you feel free to change Settings.get[:manager][:ThreadsCount]',
               'and Settings.get[:manager][:delay] (see readme.md for more information).'

      block_size    = Settings.get[:manager][:TransactionBlockSize]
      threads_count = Settings.get[:manager][:ThreadsCount]
      delay         = Settings.get[:manager][:delay]

      # dynamic bunch_size determination for better perfomance
      bunch_size    = [count / threads_count, block_size].max
      bunch = Array.new(threads_count) do |i|
        GemProxy.where(loaded: false).or(GemProxy.where(need_update: true))
                .limit(bunch_size).offset(i * bunch_size).map
      end # bunch = [ [], [], [], [], ... [] ]

      threads = []
      updated = 0
      need_update = GemProxy.where(need_update: true).count
      threads_count.times do |i|
        threads << Thread.new(bunch[i]) do |bunch|
          sleep delay * i
          bunch.each_slice(block_size) do |records_block|
            update_gems records_block
            GemProxy.transaction do
              records_block.each(&:save)
            end
            updated += 1
            Msg.print('Full information added to the database for ' \
                       "#{[updated * block_size, need_update].min}" \
                       "/#{need_update} gems.", "\r")
          end
        end
      end # thread
      threads.each(&:join)

      Msg.puts '', 'Update successful!'
    end # method
  end # module Manager
end # module RubyGem
