# encoding: utf-8
Gem::Specification.new do |s|
  s.name          = 'rudisco'
  s.version       = '0.9.0'
  s.date          = '2017-02-05'
  s.authors       = ['Kuzichev Michael']
  s.license       = 'MIT'
  s.email         = 'kMedvedu@gmail.com'

  s.files         = Dir['readme.md', 'license.md', 'Rakefile', 'sources/**/*', 'rakefiles/**/*']
  s.files.reject! { |file_name| file_name.include? "development" }

  s.summary = 'Rubygems sqlite3 database (includes information about ~ 126000 gems). Table gems consist of next columns: name, description, authors, version, license, sha, source_code_url and more. Full table structure described in gem.rb file.'

  s.test_files    = Dir['spec/**/*.rb']
  s.homepage      = 'https://github.com/Medvedu/rudisco'
  s.require_paths = ['sources']

  s.required_ruby_version = '>= 2.1.10'

  s.add_runtime_dependency 'rake'

  s.add_dependency 'sqlite3',         '~> 1.3.13', '>= 1.3.13'
  s.add_dependency 'sequel',          '~> 4.42.1', '>= 4.42.1'

  s.requirements << 'wget' # @see Rudisco::Helpers#download
  s.requirements << 'git'  # @see Rudisco::Helpers#git_clone
end
