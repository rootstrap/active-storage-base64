require 'active_support/concern'
require 'active_storage/attached'

module ActiveStorageSupport
  module SupportForBase64
    extend ActiveSupport::Concern
    class_methods do
      def has_one_base64_attached(name, dependent: :purge_later, service: nil, strict_loading: false, &block)
        has_one_attached name, dependent: dependent, service: service, strict_loading: strict_loading, &block

        generated_association_methods.class_eval <<-CODE, __FILE__, __LINE__ + 1
          # frozen_string_literal: true
          def #{name}
            @active_storage_attached ||= {}
            @active_storage_attached[:#{name}] ||= ActiveStorageSupport::Base64One.new("#{name}", self)
          end

          def #{name}=(attachable)
            attachment_changes["#{name}"] =
              if attachable.presence.nil?
                ActiveStorage::Attached::Changes::DeleteOne.new("#{name}", self)
              else
                ActiveStorage::Attached::Changes::CreateOne.new(
                  "#{name}", self, ActiveStorageSupport::Base64One.from_base64(attachable)
                )
              end
          end
        CODE
      end

      def has_many_base64_attached(name, dependent: :purge_later, service: nil, strict_loading: false, &block)
        has_many_attached name, dependent: dependent, service: service, strict_loading: strict_loading, &block

        generated_association_methods.class_eval <<-CODE, __FILE__, __LINE__ + 1
          # frozen_string_literal: true
          def #{name}
            @active_storage_attached ||= {}
            @active_storage_attached[:#{name}] ||= ActiveStorageSupport::Base64Many.new("#{name}", self)
          end

          def #{name}=(attachables)
            if ActiveStorage.replace_on_assign_to_many
              attachment_changes["#{name}"] =
                if Array(attachables).none?
                  ActiveStorage::Attached::Changes::DeleteMany.new("#{name}", self)
                else
                  ActiveStorage::Attached::Changes::CreateMany.new(
                    "#{name}", self, ActiveStorageSupport::Base64Many.from_base64(attachables)
                  )
                end
            else
              ActiveSupport::Deprecation.warn \
                "config.active_storage.replace_on_assign_to_many is deprecated and will be removed in Rails 7.1. " \
                "Make sure that your code works well with config.active_storage.replace_on_assign_to_many set to true before upgrading. " \
                "To append new attachables to the Active Storage association, prefer using `attach`. " \
                "Using association setter would result in purging the existing attached attachments and replacing them with new ones."

              if Array(attachables).any?
                attachment_changes["#{name}"] =
                  ActiveStorage::Attached::Changes::CreateMany.new(
                    "#{name}", self, #{name}.blobs + ActiveStorageSupport::Base64Many.from_base64(attachables)
                  )
              end
            end
          end
        CODE
      end
    end
  end
end
