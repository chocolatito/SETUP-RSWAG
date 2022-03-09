# frozen_string_literal: true

# == Schema Information
#
# Table name: testimonials
#
#  id           :bigint           not null, primary key
#  content      :string
#  discarded_at :datetime
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_testimonials_on_discarded_at  (discarded_at)
#
class Testimonial < ApplicationRecord
  include Discard::Model
  paginates_per 10
  has_one_attached :image

  validates :name, presence: true, length: { minimum: 2 }
  validates :content, presence: true, length: { minimum: 5 }
end
