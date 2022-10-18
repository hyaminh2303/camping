FactoryBot.define do
  factory :booking_contact_information do
    email { "MyString" }
    name { "MyString" }
    post_code { "MyString" }
    address { "MyString" }
    birthday { "MyString" }
    phone_number { "MyString" }
  end
end

# == Schema Information
#
# Table name: booking_contact_informations
#
#  id                :bigint           not null, primary key
#  address           :string
#  birthday          :date
#  email             :string
#  name              :string
#  number_of_female  :integer
#  number_of_male    :integer
#  phone_number      :string
#  post_code         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  travel_package_id :bigint
#
# Indexes
#
#  index_booking_contact_informations_on_travel_package_id  (travel_package_id)
#
