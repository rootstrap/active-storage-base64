module ActiveStorageSupport
  class Base64One < ActiveStorage::Attached::One
    def attach(attachable)
      attachment = ActiveStorageSupport::Base64Attach.attachment_from_base64(data: attachable)
      super attachment
    end
  end
end
