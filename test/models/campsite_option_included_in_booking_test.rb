require "test_helper"

class CampsiteOptionIncludedInBookingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: campsite_options_included_in_booking
#
#  id                                     :bigint           not null, primary key
#  name                                   :string
#  price                                  :integer
#  quantity                               :integer          default(0)
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  campsite_booking_id                    :bigint
#  campsite_option_included_in_booking_id :bigint           not null
#  campsite_plan_option_id                :bigint
#
