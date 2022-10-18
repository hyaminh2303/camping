class CampsitePlanFeeDetail < ApplicationRecord
  attr_accessor :_destroy

  belongs_to :normal_campsite_plan_fee,
             class_name: "CampsitePlanFee",
             optional: true,
             foreign_key: :normal_campsite_plan_fee_id,
             inverse_of: :normal_campsite_plan_fee_detail

  belongs_to :classification_day_campsite_plan_fee,
             class_name: "CampsitePlanFee",
             optional: true,
             foreign_key: :classification_day_campsite_plan_fee_id,
             inverse_of: :classification_day_campsite_plan_fee_details

  belongs_to :classification_day_setting, optional: true

  validates :basic_fee, :number_of_people_pet_included, :extra_person_fee,
            numericality: { greater_than_or_equal_to: 0 }, allow_blank: true, # https://app.clickup.com/t/1zaa2g7
            if: -> {
              (normal_campsite_plan_fee.present? && normal_campsite_plan_fee.normal?) || (classification_day_campsite_plan_fee.present? && classification_day_campsite_plan_fee.classification_day?)}
end

# == Schema Information
#
# Table name: campsite_plan_fee_details
#
#  id                                      :bigint           not null, primary key
#  basic_fee                               :integer
#  extra_person_fee                        :integer
#  number_of_people_pet_included           :integer
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  classification_day_campsite_plan_fee_id :integer
#  classification_day_setting_id           :integer
#  normal_campsite_plan_fee_id             :integer
#
