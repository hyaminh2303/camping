class CampCarOptionIncludedInBooking < ApplicationRecord
  MIN_NUMBER_OF_QUANTITY = 0

  belongs_to :camp_car_option
  belongs_to :camp_car_booking

  validates_numericality_of :fee_per_day, greater_than_or_equal_to: 0
  validates_numericality_of :quantity, greater_than_or_equal_to: MIN_NUMBER_OF_QUANTITY

  scope :greater_than_zero, -> { where('quantity > 0') }

  def total_fee_per_day
    self.quantity * self.fee_per_day
  end
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
