# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id            :bigint           not null, primary key
#  about_us_text :text
#  address       :string
#  discarded_at  :datetime
#  email         :string           not null
#  name          :string           not null
#  phone         :integer
#  welcome_text  :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_organizations_on_discarded_at  (discarded_at)
#  index_organizations_on_email         (email) UNIQUE
#
class OrganizationSerializer
  include JSONAPI::Serializer
  attributes :email, :name, :welcome_text, :address, :phone, :about_us_text
end
