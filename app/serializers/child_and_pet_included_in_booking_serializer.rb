class ChildAndPetIncludedInBookingSerializer < ApplicationSerializer
attributes :entity_label, :entity_type, :fee, :quantity, :child_and_pet_setting_id
end

# == Schema Information
#
# Table name: child_and_pet_included_in_bookings
#
#  id                                   :bigint           not null, primary key
#  entity_label                         :string
#  entity_type                          :string
#  fee                                  :integer          default(0)
#  quantity                             :integer          default(0)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  campsite_booking_id                  :bigint
#  child_and_pet_included_in_booking_id :bigint           not null
#  child_and_pet_setting_id             :bigint
#
