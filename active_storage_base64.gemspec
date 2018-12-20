Gem::Specification.new do |s|
  s.name = 'active_storage_base64'
  s.version = '0.0.0'
  s.date = '2018-11-07'
  s.summary = 'base64 support for ActiveStorage'
  s.files = [
    'lib/active_storage_base64.rb'
  ]
  s.require_paths = ['lib']
  s.authors = ['Nicolas Fabre, Ricky Ricoch']
  s.license = 'MIT'

  s.required_ruby_version = ">= 2.2.2"

  # Dependencies
  s.add_dependency 'rails', '~> 5.2.0', '<= 5.2.2'

  # Development dependencies
  s.add_development_dependency 'rubocop', '~> 0.56.0'
  s.add_development_dependency 'reek', '~> 4.8.1'
  s.add_development_dependency 'rspec-rails', '~> 3.8.0'
  s.add_development_dependency 'sqlite3', '1.3.13'
  s.add_development_dependency 'pry-rails', '~> 0.3.6'
end
