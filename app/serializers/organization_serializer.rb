# frozen_string_literal: true

class OrganizationSerializer
  include JSONAPI::Serializer
  attributes :email, :name, :welcome_text, :address, :phone, :about_us_text
end
