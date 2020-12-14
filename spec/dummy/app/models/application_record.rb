require_relative '../../../../lib/active_storage_base64.rb'

class ApplicationRecord < ActiveRecord::Base
  include ActiveStorageSupport::SupportForBase64

  self.abstract_class = true
end
