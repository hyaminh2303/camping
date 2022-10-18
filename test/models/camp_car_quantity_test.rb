require "test_helper"

class CampCarQuantityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: camp_car_quantities
#
#  id          :bigint           not null, primary key
#  date        :date
#  quantity    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  camp_car_id :bigint
#
# Indexes
#
#  index_camp_car_quantities_on_camp_car_id  (camp_car_id)
#
