# Helper method to decode a base64 file and create a StringIO file
module ActiveStorageSupport
  module Base64Attach
    module_function

    def attachment_from_data(attachment)
      if attachment.is_a?(Hash)
        base64_data = attachment.delete(:data)
        if base64_data.try(:is_a?, String) && base64_data =~ /^data:(.*?);(.*?),(.*)$/

          attachment[:io] = StringIO.new(Base64.decode64(Regexp.last_match(3)))
          attachment[:content_type] = Regexp.last_match(1) unless attachment[:content_type]
          attachment[:filename] = Time.current.to_i.to_s unless attachment[:filename]
        end
      end

      attachment
    end
  end
end
