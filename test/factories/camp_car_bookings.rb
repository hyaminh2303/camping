FactoryBot.define do
  factory :camp_car_booking do
    start_date { "" }
    end_date { "" }
    camp_car { nil }
    travel_package { nil }
  end
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
