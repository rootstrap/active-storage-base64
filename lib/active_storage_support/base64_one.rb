module ActiveStorageSupport
  class Base64One < ActiveStorage::Attached::One
    def attach(attachable)
      super self.class.from_base64(attachable)
    end

    def self.from_base64(attachable)
      ActiveStorageSupport::Base64Attach.attachment_from_data(attachable)
    end
  end
end
