module ActiveStorageSupport
  class Base64Many < ActiveStorage::Attached::Many
    def attach(*attachables)
      super base64_attachments(attachables)
    end

    def base64_attachments(attachments)
      attachments.flatten.map do |attachment|
        ActiveStorageSupport::Base64Attach.attachment_from_data(attachment)
      end
    end
  end
end
