# encoding: utf-8
Gem::Specification.new do |s|
  s.name          = 'rudisco'
  s.version       = '1.0.2'
  s.date          = '2017-02-05'
  s.authors       = ['Kuzichev Michael']
  s.license       = 'MIT'
  s.email         = 'kMedvedu@gmail.com'
  s.summary       = 'Rubygems sqlite3 database (includes information about ~ 126000 gems). Table gems consist of next columns: name, description, authors, version, license, sha, source_code_url and more. Supports CLI.'
  s.homepage      = 'https://github.com/Medvedu/rudisco'

  s.files         = Dir['readme.md', 'license.md', 'Gemfile', 'Rakefile', 'bin/**/*', 'lib/**/*', 'rakefiles/**/*', 'docs/**/*']
  s.files.reject! { |file_name| file_name.include? "development" }

  s.bindir = 'bin'
  s.executables << 'rudisco'

  s.test_files = Dir['spec/**/*.rb']

  s.required_ruby_version = '>= 2.1.10'

  s.add_runtime_dependency 'rake', '~> 12.0', '>= 12.0.0'

  s.add_dependency 'sqlite3',               '~> 1.3.13', '>= 1.3.13'
  s.add_dependency 'sequel',                '~> 4.42.1', '>= 4.42.1'
  s.add_dependency 'thor',                  '~> 0.19.4', '>= 0.19.4'
  s.add_dependency 'command_line_reporter', '~> 3.0',    '>= 3.0'

  s.requirements << 'wget' # @see Rudisco::Helpers#download
  s.requirements << 'git'  # @see Rudisco::Helpers#git_clone
end
