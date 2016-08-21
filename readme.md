# RubyGems discover

## About

Collect&Discover tool for RubyGems. 

## Samples

### discover popular gems

```ruby
require '../lib/rubygems.rb'

RubyGem::Gem.connect

hot_with_git_sourse = RubyGem::Gem.where('downloads_count_all < 2000000 ')
                                  .where('downloads_count_last > 500000' )
                                  .where('sourse_code_uri is not NULL')
                                  .limit(100)

hot_with_git_sourse.each do |g|
  puts "Gem name:     #{g.name}"
  puts "Description:  #{g.description}"
  puts "Sourse link:  #{g.sourse_code_uri}"
  puts "Authors:      #{g.authors}", ""
end

```

#### or

```ruby
require '../lib/rubygems.rb'

RubyGem::Gem.connect

popular = RubyGem::Gem.where('downloads_count_all > 4000000 ')
                      .order('downloads_count_last DESC')
                      .limit(100)

popular.each do |g|
  puts "Gem name:     #{g.name}"
  puts "Description:  #{g.description}"
  puts "Authors:      #{g.authors}", ''
end
```

### search

```ruby
require '../lib/rubygems.rb'

RubyGem::Gem.connect(verbose: false)

count = RubyGem::Gem.search('mit', search: [:license]).count
puts "Gems count published with MIT license: #{count}", ''

puts "Gems with 'CRC32' keyword in a name or description."
RubyGem::Gem.search('CRC32', search: [:name, :description]).each do |g|
  puts "Gem name:     #{g.name}"
  puts "Description:  #{g.description}"
  puts "Authors:      #{g.authors}", ''
end

```

### update by rake (+cron?)

```ruby
#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'rake'

# TODO: change for gem path, when it will be published to rubygems…
require "#{__dir__}/../lib/rubygems.rb"

desc 'Update rubygems database. Required external connection to '       \
     'rubygems.org. Highly recommended for launch as cron since it is ' \
     'a long-term task.'

task :update_rubygems_db do
  RubyGem::Gem.connect(verbose: true, skip_headers_download: false)
  RubyGem::Gem.update(manager: { ThreadsCount: 20 })
end

```

### download

… not implemended …

## Installation

1. Make sure you have installed postgresql database and bin/gem tool.

### dependencies

> /bin/gem 
> /bin/createuser
> /bin/createdb

2. Git clone this project
3. cd to project
4. write into your console 

> $ rubygems rake update_rubygems_db

5. Wait. It will be long. Sorry, but there is nothing to do with rubygems cooldown&response time. (If you know how to descrease cooldown or have any other tip, feel free to contact)

License
----

MIT
