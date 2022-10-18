require "test_helper"

class CampsitePlanPriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
