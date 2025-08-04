# frozen_string_literal: true

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  # Activate the gem you are reporting the issue against.
  gem 'rails', '~> 7.1'
  gem 'sqlite3'
  gem 'active_storage_base64', github: 'rootstrap/active-storage-base64', branch: 'master'
end

require 'active_record/railtie'
require 'active_storage/engine'
require 'tmpdir'

class TestApp < Rails::Application
  config.root = __dir__
  config.hosts << 'example.org'
  config.eager_load = false
  config.session_store :cookie_store, key: 'cookie_store_key'
  secrets.secret_key_base = 'secret_key_base'

  config.logger = Logger.new($stdout)
  Rails.logger  = config.logger

  config.active_storage.service = :local
  config.active_storage.service_configurations = {
    local: {
      root: Dir.tmpdir,
      service: 'Disk'
    }
  }
end

ENV['DATABASE_URL'] = 'sqlite3::memory:'

Rails.application.initialize!

require ActiveStorage::Engine.root.join('db/migrate/20170806125915_create_active_storage_tables.rb').to_s

ActiveRecord::Schema.define do
  CreateActiveStorageTables.new.change

  create_table :users, force: true
end

class User < ActiveRecord::Base
  include ActiveStorageSupport::SupportForBase64

  has_one_base64_attached :avatar
end

require 'minitest/autorun'

class BugTest < Minitest::Test
  def test_attachment
    filename = 'generic-logo.png'
    file = File.open(File.expand_path(File.join(File.dirname(__FILE__), 'spec', 'fixtures', filename))).read
    data = "data:image/png;base64,#{Base64.encode64(file)}"

    user = User.create
    user.avatar.attach(data: data, filename: filename)
    user.save!

    assert_equal(filename, user.avatar.filename.to_s)
    assert_equal(File.open(ActiveStorage::Blob.service.send(:path_for, user.avatar.key)).read, file)
  end
end
