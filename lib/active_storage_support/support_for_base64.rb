require 'active_support/concern'
require 'active_storage/attached'

module ActiveStorageSupport
  module SupportForBase64
    extend ActiveSupport::Concern
    class_methods do
      def has_one_base64_attached(name, dependent: :purge_later)
        has_one_attached name, dependent: dependent

        add_helper_method(ActiveStorageSupport::Base64One, name, dependent: dependent)
      end

      def has_many_base64_attached(name, dependent: :purge_later)
        has_many_attached name, dependent: dependent

        add_helper_method(ActiveStorageSupport::Base64Many, name, dependent: dependent)
      end

      def add_helper_method(type, name, dependent:)
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{name}
            @active_storage_attached_#{name} ||=
              #{type}.new("#{name}", self, dependent: #{dependent == :purge_later ? ':purge_later' : 'false'})
          end

          def #{name}=(data)
            #{name}.attach(data)
          end
        CODE
      end
    end
  end
end
