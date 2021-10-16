ENV['RAILS_ENV'] ||= 'test'
require 'dummy/config/environment'
require 'fileutils'
require 'simplecov'

FileUtils.rm_rf('./spec/dummy/tmp/storage')

SimpleCov.start

Rails.application.routes.default_url_options[:host] = 'localhost:3000'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

load 'dummy/db/schema.rb'
