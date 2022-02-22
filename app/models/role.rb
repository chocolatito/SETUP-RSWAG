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
class Role < ApplicationRecord
  include Discard::Model
  has_many :users, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2 }
  validates :description, presence: true, length: { minimum: 5 }
end
