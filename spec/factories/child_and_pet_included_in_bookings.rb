FactoryBot.define do
  factory :child_and_pet_included_in_booking do
    fee { "9.99" }
    campsite_booking { nil }
    label { "MyString" }
    child_and_pet_setting { nil }
    quantity { 1 }
  end
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
