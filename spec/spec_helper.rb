ENV['RAILS_ENV'] ||= 'test'
require_relative 'dummy/config/environment.rb'
require 'pry'

require 'simplecov'
SimpleCov.start

Rails.application.routes.default_url_options[:host] = 'localhost:3000'

require 'tmpdir'
ActiveStorage::Blob.service =
  ActiveStorage::Service::DiskService.new(root: Dir.mktmpdir('active_storage_tests'))

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

load 'dummy/db/schema.rb'
