# frozen_string_literal: true

class MembersSerializer
  include JSONAPI::Serializer
  attributes :name, :description
  attribute :image do |object|
    return object.image_url if Rails.env.production?

    if Rails.env.development? && !object.image.key.nil?
      ActiveStorage::Blob.service.path_for(object.image.key)
    end
  end
end
