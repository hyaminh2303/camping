class CampCarOptionIncludedInBookingSerializer < ApplicationSerializer
attributes :fee_per_day, :quantity
end

# == Schema Information
#
# Table name: camp_car_options_included_in_booking
#
#  id                  :bigint           not null, primary key
#  fee_per_day         :integer
#  name                :string
#  quantity            :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  camp_car_booking_id :bigint
#  camp_car_option_id  :bigint
#
