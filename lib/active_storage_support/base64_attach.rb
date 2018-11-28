# Helper method to decode a base64 file and create a StringIO file
module ActiveStorageSupport
  module Base64Attach
    module_function

    def attachment_from_base64(data:, filename: Time.current.to_i.to_s)
      return data unless data.is_a?(String) && data.strip.start_with?('data')

      base64_image = data.sub(/^data:.*,/, '')
      decoded_image = Base64.decode64(base64_image)
      image_io = StringIO.new(decoded_image)

      { io: image_io, filename: filename }
    end
  end
end
