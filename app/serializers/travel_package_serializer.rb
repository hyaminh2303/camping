class TravelPackageSerializer < ApplicationSerializer
  include ApplicationHelper
  attributes :booking_type, :payment_method, :status, :total_price

  has_one :campsite_booking
  has_one :camp_car_booking

  def total_price
    gcamp_round_price(self.object.total_price)
  end
end

# == Schema Information
#
# Table name: travel_packages
#
#  id                                  :bigint           not null, primary key
#  booked_by_type                      :string
#  booking_ref_number                  :string
#  booking_type                        :string
#  canceled_at                         :datetime
#  canceled_by_type                    :string
#  credit_card_addition_expired_at     :datetime
#  is_adding_credit_card_reminder_sent :boolean          default(FALSE)
#  is_booking_outside                  :boolean          default(FALSE)
#  payment_method                      :string
#  status                              :string
#  total_price                         :decimal(, )
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  booked_by_id                        :bigint
#  canceled_by_id                      :bigint
#  customer_user_id                    :bigint
#
# Indexes
#
#  index_travel_packages_on_booked_by         (booked_by_type,booked_by_id)
#  index_travel_packages_on_canceled_by       (canceled_by_type,canceled_by_id)
#  index_travel_packages_on_customer_user_id  (customer_user_id)
#
