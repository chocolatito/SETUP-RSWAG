# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id           :bigint           not null, primary key
#  content      :text             not null
#  discarded_at :datetime
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_activities_on_discarded_at  (discarded_at)
#  index_activities_on_name          (name) UNIQUE
#
FactoryBot.define do
  factory :activity do
    name { Faker::TvShows::BreakingBad.character }
    content { Faker::Books::Lovecraft.sentence }
    trait :discarded do
      discarded_at { rand(1..1_000_000).days.ago }
    end
  end
end
