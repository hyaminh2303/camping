class CampsiteEntranceFee < ApplicationRecord
  has_many :child_and_pet_entrance_fees, dependent: :destroy
  belongs_to :campsite

  validates :adult_fee, presence: true
  validates_numericality_of :adult_fee, greater_than_or_equal_to: 0

  accepts_nested_attributes_for :child_and_pet_entrance_fees, allow_destroy: true
end

# == Schema Information
#
# Table name: campsite_entrance_fees
#
#  id          :bigint           not null, primary key
#  adult_fee   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  campsite_id :integer
#
