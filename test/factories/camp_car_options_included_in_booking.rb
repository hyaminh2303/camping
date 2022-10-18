FactoryBot.define do
  factory :camp_car_option_included_in_booking do
    name { "MyString" }
    price { "9.99" }
    quantity { 1 }
    camp_car { nil }
    camp_car_booking { nil }
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
