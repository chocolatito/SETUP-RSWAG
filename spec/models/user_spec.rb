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
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'factory' do
    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:role) }
    it { is_expected.to have_one_attached(:image) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value(Faker::Internet.email).for(:email) }
    it { is_expected.not_to allow_value('example.mail.com').for(:email) }
    it { is_expected.not_to allow_value('@example.mail').for(:email) }
    it { is_expected.not_to allow_value('').for(:email) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2).is_at_most(15) }
    it { is_expected.to validate_length_of(:last_name).is_at_least(2).is_at_most(15) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe 'database' do
    it { is_expected.to have_db_column(:id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_column(:first_name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:last_name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:password).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:discarded_at).of_type(:datetime) }
    it { is_expected.to have_db_index(:discarded_at) }
  end
end
