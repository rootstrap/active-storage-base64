class User < ApplicationRecord
  has_one_base64_attached :avatar
  has_many_base64_attached :pictures
end
