require "test_helper"

class AppSettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: app_settings
#
#  id                             :bigint           not null, primary key
#  camp_car_commission_percentage :float            default(23.5)
#  campsite_commission_percentage :float            default(10.5)
#  publication_fee                :integer          default(5000)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
