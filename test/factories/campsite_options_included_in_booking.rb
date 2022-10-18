FactoryBot.define do
  factory :campsite_option_included_in_booking do
    campsite_plan_option { nil }
    campsite_booking { nil }
    name { "MyString" }
    price { "9.99" }
    quantity { 1 }
  end
end

# == Schema Information
#
# Table name: campsite_options_included_in_booking
#
#  id                                     :bigint           not null, primary key
#  name                                   :string
#  price                                  :integer
#  quantity                               :integer          default(0)
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  campsite_booking_id                    :bigint
#  campsite_option_included_in_booking_id :bigint           not null
#  campsite_plan_option_id                :bigint
#
