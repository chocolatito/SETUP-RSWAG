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
FactoryBot.define do
  factory :organization do
    name { Faker::TvShows::BreakingBad.character }
    address { Faker::Address.street_address }
    phone { Faker::Number.number(digits: 5) }
    email { Faker::Internet.email }
    welcome_text { Faker::Books::Lovecraft.sentence }
    about_us_text { Faker::Books::Lovecraft.sentence }
  end

  trait :discarded do
    discarded_at { rand(1..1_000_000).days.ago }
  end
end
