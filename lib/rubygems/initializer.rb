# encoding: utf-8

# no-doc
module RubyGem
  #
  # create role/database/schema if not exists.
  #
  module Initializer
    #
    #
    #
    def self.extended(_arg)
      file = File.join(__dir__, '..', '..', 'tmp', 'config.yaml')
      if File.exist?(file)
        config = YAML.load_file(file).to_h
      else
        config = Settings.get[:database]
        File.open(file, 'w') { |f| f.write config.to_yaml; f.close }
      end

      begin
        PG::Connection.open(dbname: config[:database])
      rescue PG::ConnectionBad
        Msg.puts 'Database does not exist. Creating… '

        system("export PGPASSWORD=#{config[:password]};                   \
                createuser #{config[:username]} -d -R -S")

        system("export PGPASSWORD=#{config[:password]};                   \
                createdb #{config[:database]} -E #{config[:encoding]}     \
                                              -h #{config[:host]}         \
                                              -U #{config[:username]} ")
      end # rescue

      ActiveRecord::Base.establish_connection config
      ActiveSupport::Deprecation.silenced = true
      GemsSchema.migrate(:create) if ActiveRecord::Base.connection
                                                       .tables.count.zero?
      ActiveSupport::Deprecation.silenced = false
    end # method included

    private

    #
    # table gems migration:
    #
    class GemsSchema < ActiveRecord::Migration
      def create
        create_table :gem_proxies do |t|
          t.text    :description
          t.string  :name
          t.string  :authors
          t.string  :version
          t.string  :project_uri
          t.string  :license
          t.integer :downloads_count_all
          t.integer :downloads_count_last
          t.string  :sha
          t.string  :sourse_code_uri
          t.string  :gem_uri
          t.boolean :loaded, default: false
          t.boolean :need_update, default: true
          t.timestamps null: false
        end
        Msg.puts 'Migration finished.'
      end
    end
  end # Module Initializer
end # RubyGem
