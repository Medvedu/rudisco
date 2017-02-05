# Rudisco

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
  require 'rudisco'
  
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

### Database update

With verbose:

```shell
  $ cd %gemdir
  $ bundle exec rake Rudisco:update
```

Silent:

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
