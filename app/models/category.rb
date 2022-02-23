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
class Category < ApplicationRecord
  include Discard::Model

  has_one_attached :image

  validates :name, presence: true, length: { minimum: 4 }
  validates :description, presence: true, length: { minimum: 4 }
end