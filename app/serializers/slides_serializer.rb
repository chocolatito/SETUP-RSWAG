# frozen_string_literal: true

class SlidesSerializer
  include JSONAPI::Serializer
  attributes :order
  attribute :image do |object|
    return object.image_url if Rails.env.production?

    ActiveStorage::Blob.service.path_for(object.image.key) if Rails.env.development?
  end
end
