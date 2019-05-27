module ActiveStorageSupport
  class Base64Many < ActiveStorage::Attached::Many
    def attach(*attachables)
      super self.class.from_base64(attachables)
    end

    def self.from_base64(attachables)
      attachables = [attachables] unless attachables.is_a?(Array)

      attachables.flatten.map do |attachable|
        ActiveStorageSupport::Base64Attach.attachment_from_data(attachable)
      end
    end
  end
end
