require "test_helper"

class CampsitePlanQuantityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: campsite_plan_quantities
#
#  id               :bigint           not null, primary key
#  date             :date
#  quantity         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  campsite_plan_id :bigint
#
# Indexes
#
#  index_campsite_plan_quantities_on_campsite_plan_id  (campsite_plan_id)
#
