# Helper method to decode a base64 file and create a StringIO file
module ActiveStorageSupport
  module Base64Attach
    module_function

    def attachment_from_data(attachment)
      fill_attachment_data(attachment, attachment.delete(:data)) if attachment.is_a?(Hash)

      attachment
    end

    def fill_attachment_data(attachment, base64_data)
      return unless base64_data.try(:is_a?, String) && base64_data =~ /^data:(.*?);(.*?),(.*)$/

      attachment[:io] = StringIO.new(Base64.decode64(Regexp.last_match(3)))
      attachment[:content_type] ||= Regexp.last_match(1)
      attachment[:filename]     ||= Time.current.to_i.to_s
    end
  end
end
