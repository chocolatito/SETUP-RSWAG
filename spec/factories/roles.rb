# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id           :bigint           not null, primary key
#  description  :string
#  discarded_at :datetime
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_roles_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :role do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
  end
end
