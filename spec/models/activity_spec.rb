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
require 'rails_helper'

RSpec.describe Activity, type: :model do
  subject { build(:activity) }

  describe 'factory' do
    it { is_expected.to be_valid }
  end

  describe 'associations' do
    it { is_expected.to have_one_attached(:image) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(40) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_least(2) }
  end

  describe 'database' do
    it { is_expected.to have_db_column(:id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:content).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:discarded_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_index(:name).unique }
  end
end
