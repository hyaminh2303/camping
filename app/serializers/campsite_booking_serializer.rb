class CampsiteBookingSerializer < ApplicationSerializer
  attributes :check_in, :check_out, :number_of_adult, :number_of_nights, :number_of_children, :campsite_plan_id

  has_many :child_and_pet_included_in_bookings
end

# == Schema Information
#
# Table name: campsite_bookings
#
#  id                  :bigint           not null, primary key
#  check_in            :datetime
#  check_out           :datetime
#  note                :text
#  number_of_adult     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  campsite_plan_id    :bigint
#  supplier_company_id :bigint
#  travel_package_id   :bigint
#
# Indexes
#
#  index_campsite_bookings_on_campsite_plan_id     (campsite_plan_id)
#  index_campsite_bookings_on_supplier_company_id  (supplier_company_id)
#  index_campsite_bookings_on_travel_package_id    (travel_package_id)
#
