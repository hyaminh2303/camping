require "test_helper"

class CampsitePlanDailyFeeSettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: campsite_plan_daily_fee_settings
#
#  id                            :bigint           not null, primary key
#  basic_fee                     :integer
#  date                          :date
#  extra_person_fee              :integer
#  number_of_people_pet_included :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  campsite_plan_id              :integer
#
