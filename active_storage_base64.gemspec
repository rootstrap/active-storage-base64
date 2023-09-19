Gem::Specification.new do |s|
  s.name = 'active_storage_base64'
  s.version = '3.0.0'
  s.summary = 'Base64 support for ActiveStorage'
  s.description = s.summary

  s.files = Dir['LICENSE.txt', 'README.md', 'lib/**/*']

  s.require_paths = ['lib']
  s.authors = ['Ricardo Cortio', 'Santiago Bartesaghi']
  s.license = 'MIT'
  s.homepage = 'https://github.com/rootstrap/active-storage-base64'
  s.email = ['ricardo@rootstrap.com', 'santiago.bartesaghi@rootstrap.com']

  s.required_ruby_version = '>= 2.7.0'

  # Dependencies
  s.add_dependency 'activestorage', '> 7.0'
  s.add_dependency 'activesupport', '> 7.0'

  # Development dependencies
  s.add_development_dependency 'rails', '> 7.0'
  s.add_development_dependency 'pry-rails', '~> 0.3.6'
  s.add_development_dependency 'reek', '~> 6.0.6'
  s.add_development_dependency 'rspec-rails', '~> 3.8.0'
  s.add_development_dependency 'rubocop', '~> 1.22.0'
  s.add_development_dependency 'simplecov', '~> 0.17.1'
  s.add_development_dependency 'sqlite3', '1.4.2'
  s.add_development_dependency 'image_processing', '~> 1.2'
end
