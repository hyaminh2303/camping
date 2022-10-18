class ChildAndPetEntranceFee < ApplicationRecord
  attr_accessor :_destroy

  belongs_to :child_and_pet_setting
  belongs_to :campsite_entrance_fee

  validates :fee_value, numericality: { greater_than_or_equal_to: 0 }

end

# == Schema Information
#
# Table name: child_and_pet_entrance_fees
#
#  id                       :bigint           not null, primary key
#  fee_value                :integer          default(0)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  campsite_entrance_fee_id :bigint
#  child_and_pet_setting_id :bigint
#
# Indexes
#
#  index_child_and_pet_entrance_fees_on_campsite_entrance_fee_id  (campsite_entrance_fee_id)
#  index_child_and_pet_entrance_fees_on_child_and_pet_setting_id  (child_and_pet_setting_id)
#
