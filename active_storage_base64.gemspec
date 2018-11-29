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

  #Dependencies
  s.add_dependency 'rails', '>= 5.2.0'

  #Development dependencies
  s.add_development_dependency 'rubocop', '>= 0.49.1'
end
