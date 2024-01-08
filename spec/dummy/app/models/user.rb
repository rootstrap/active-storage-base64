class User < ApplicationRecord
  has_one_base64_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fit: [1, 1]
  end

  has_many_base64_attached :pictures do |attachable|
    attachable.variant :thumb, resize_to_fit: [1, 1]
  end

  has_one_base64_attached :file
end
