# Rudisco [![Build Status](https://travis-ci.org/Medvedu/rudisco.svg?branch=master)](https://travis-ci.org/Medvedu/rudisco)

## Description
 
Gems local database (based on [Rubygems](https://rubygems.org)). Includes information about ~ 126000 gems.

Table _gems_ consist of next columns: _name, description, authors, version, license, sha, source_code_url_ and more. Full table structure described in gem.rb file.

## Installation

```shell
  $ gem install rudisco
```

## Usage

### Database usage example

```ruby
  gems = Rudisco::Gem # Sequel::Model
  
  top = gems.where{ total_downloads > 50000000 }
            .select(:name, :description, :source_code_url)
  
  top.each do |record|
    puts record[:name]
    puts record[:description]
    puts record[:source_code_url] if record[:source_code_url]
    puts
  end
```

### Simple search gems by selected phrase

```ruby
  phrase = 'rails'
  gems = Rudisco::Gem.find_phrase(phrase)
                     .select(:name, :description)
  
  gems.each do |record|
    puts record[:name]
    puts record[:description]
    puts
  end
```

### Open documentation and download gems

```ruby
  path_to_load = File.join(__dir__, '..', 'tmp')
  
  sample = Rudisco::Gem.exclude(source_code_url: '').first
  sample.action(:open_sources)
        .action(:git_clone, path: path_to_load)
        
  sample2 = Rudisco::Gem.limit(2)
  sample2.action(:download, path: path_to_load)
```
### Update database

#### Throw CLI

```shell
  $ gem install rudisco
  $ rudisco update
```

#### By #deep_scanning call

```ruby
  require 'rudisco'
  
  Rudisco::Gem.deep_scanning
```

## Todo

Integrate with Github for better search results.

## Dependencies

  * Ruby 2.1.0 or higher
  * sqlite3 ~> 1.3.13
  * sequel  ~> 4.42.1

## License
----

Released under the MIT License. See the [LICENSE](./LICENSE) file for further details.
