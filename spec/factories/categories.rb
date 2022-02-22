# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
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
#  index_categories_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :category do
    name { Faker::FunnyName.two_word_name }
    description { Faker::Company.catch_phrase }
  end

  # after(:build) do |category|
  #   category.image.attach(
  #     io: File.open(Rails.root.join('spec/factories_files/user_icon.jpeg')),
  #     filename: 'user_icon.jpeg',
  #     content_type: 'image/jpeg'
  #   )
  # end
end
