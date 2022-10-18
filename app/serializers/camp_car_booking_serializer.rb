class CampCarBookingSerializer < ApplicationSerializer
  attributes :start_date_of_renting, :end_date_of_renting, :number_of_nights, :camp_car_id

  has_many :camp_car_options_included_in_booking
end

# == Schema Information
#
# Table name: camp_car_bookings
#
#  id                    :bigint           not null, primary key
#  end_date_of_renting   :datetime
#  note                  :text
#  start_date_of_renting :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  camp_car_id           :bigint
#  supplier_company_id   :bigint
#  travel_package_id     :bigint
#
# Indexes
#
#  index_camp_car_bookings_on_camp_car_id          (camp_car_id)
#  index_camp_car_bookings_on_supplier_company_id  (supplier_company_id)
#  index_camp_car_bookings_on_travel_package_id    (travel_package_id)
#
