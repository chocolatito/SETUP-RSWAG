# frozen_string_literal: true

# == Schema Information
#
# Table name: slides
#
#  id              :bigint           not null, primary key
#  discarded_at    :datetime
#  order           :integer          not null
#  text            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_slides_on_discarded_at               (discarded_at)
#  index_slides_on_organization_id            (organization_id)
#  index_slides_on_organization_id_and_order  (organization_id,order) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
FactoryBot.define do
  factory :slide do
    text { Faker::Books::Lovecraft.sentence }
    order { Faker::Number.number(digits: 3) }

    trait :discarded do
      discarded_at { rand(1..1_000_000).days.ago }
    end

    after(:build) do |announcement|
      announcement.image.attach(
        io: File.open(Rails.root.join('spec/factories_files/test.png')),
        filename: 'test.png', content_type: 'image/jpeg'
      )
    end

    organization
  end
end
