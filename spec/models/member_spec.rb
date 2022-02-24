# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  id            :bigint           not null, primary key
#  description   :text
#  discarded_at  :datetime
#  facebook_url  :string
#  instagram_url :string
#  linkedin_url  :string
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_members_on_discarded_at  (discarded_at)
#
require 'rails_helper'

RSpec.describe Member, type: :model do
  subject { build(:member) }

  describe 'factory' do
    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to have_one_attached(:image) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2) }
    it { is_expected.to validate_length_of(:description).is_at_most(300) }
  end

  describe 'database' do
    it { is_expected.to have_db_column(:id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:linkedin_url).of_type(:string) }
    it { is_expected.to have_db_column(:facebook_url).of_type(:string) }
    it { is_expected.to have_db_column(:instagram_url).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
  end
end
