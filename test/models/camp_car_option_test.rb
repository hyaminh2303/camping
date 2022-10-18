require "test_helper"

class CampCarOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: camp_car_options
#
#  id                  :bigint           not null, primary key
#  fee_per_day         :integer
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  camp_car_option_id  :bigint           not null
#  supplier_company_id :integer
#
