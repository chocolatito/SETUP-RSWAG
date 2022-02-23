# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  discarded_at    :datetime
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  role_id         :bigint           not null
#
# Indexes
#
#  index_users_on_discarded_at  (discarded_at)
#  index_users_on_email         (email) UNIQUE
#  index_users_on_role_id       (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#
class User < ApplicationRecord
  has_secure_password

  include Discard::Model
  belongs_to :role
  has_one_attached :image
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP,
                              message: 'Must be a valid email address' },
                    uniqueness: { case_sensitive: false }
  validates :last_name, presence: true, length: { in: 2..15 }
  validates :first_name, presence: true, length: { in: 2..15 }
  validates :password, presence: true, length: { minimum: 6 }
end
