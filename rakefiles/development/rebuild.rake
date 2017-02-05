# encoding: utf-8
namespace 'Rudisco' do
namespace 'development' do
  desc "(long-term task) Creates empty sqlite database." \
       "WARNING! IT WILL DESTROY (if exists) CURRENT DATABASE"

  task 'rebuild' do
    require 'sequel'

    ### CREATE DATABASE
    path_to_db = File.join(__dir__, '../../sources/database/rudisco.db')
    File.delete path_to_db if File.exist? path_to_db
    database = Sequel.sqlite(path_to_db)

    ### CREATE SCHEME FOR +GEMS+ TABLE
    database.create_table :gems do
      primary_key :id

      Text :name
      Text :description
      Text :authors
      Text :version
      Text :license
      Text :sha

      Text :source_code_url
      Text :project_url
      Text :gem_url
      Text :wiki_url
      Text :documentation_url
      Text :mailing_list_url
      Text :bug_tracker_url

      Numeric :total_downloads
      Numeric :version_downloads

      Boolean :need_update, :default => true
    end
  end # task 'rebuild'
end # namespace 'development'
end # namespace 'Rudisco'
