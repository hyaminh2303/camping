class ChildAndPetFee < ApplicationRecord
  attr_accessor :_destroy

  belongs_to :normal_campsite_plan_fee,
             class_name: "CampsitePlanFee",
             optional: true,
             foreign_key: :normal_campsite_plan_fee_id,
             inverse_of: :normal_child_and_pet_fees

  belongs_to :classification_day_campsite_plan_fee,
             class_name: "CampsitePlanFee",
             optional: true,
             foreign_key: :classification_day_campsite_plan_fee_id,
             inverse_of: :classification_day_child_and_pet_fees

  belongs_to :child_and_pet_setting
  belongs_to :classification_day_setting, optional: true

  validates :fee_value,
            numericality: { greater_than_or_equal_to: 0 },
            if: -> {
              (normal_campsite_plan_fee.present? && normal_campsite_plan_fee.normal?) || (classification_day_campsite_plan_fee.present? && classification_day_campsite_plan_fee.classification_day?)}
end

# == Schema Information
#
# Table name: child_and_pet_fees
#
#  id                                      :bigint           not null, primary key
#  fee_value                               :integer          default(0)
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  child_and_pet_setting_id                :bigint
#  classification_day_campsite_plan_fee_id :bigint
#  classification_day_setting_id           :bigint
#  normal_campsite_plan_fee_id             :bigint
#
# Indexes
#
#  index_child_and_pet_fees_on_child_and_pet_setting_id       (child_and_pet_setting_id)
#  index_child_and_pet_fees_on_classification_day_setting_id  (classification_day_setting_id)
#  index_child_and_pet_fees_on_normal_campsite_plan_fee_id    (normal_campsite_plan_fee_id)
#
