# frozen_string_literal: true

# == Schema Information
#
# Table name: announcements
#
#  id           :bigint           not null, primary key
#  content      :text             not null
#  discarded_at :datetime
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  category_id  :bigint           not null
#
# Indexes
#
#  index_announcements_on_category_id   (category_id)
#  index_announcements_on_discarded_at  (discarded_at)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
class Announcement < ApplicationRecord
  include Discard::Model

  has_one_attached :image
  belongs_to :category

  validates :name, presence: true, length: { minimum: 2 }
  validates :content, presence: true, length: { minimum: 2 }
  validate :check_image_presence

  def check_image_presence
    errors.add(:image, 'no image file added') unless image.attached?
  end
end
