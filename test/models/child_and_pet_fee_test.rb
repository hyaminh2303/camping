require "test_helper"

class ChildAndPetFeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
