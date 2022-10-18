FactoryBot.define do
  factory :customer_user do
    family_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    family_name_pronounce { Faker::Name.last_name }
    first_name_pronounce { Faker::Name.first_name }
    sequence(:email, 1000) { |n| "person#{n}@example.com" }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    birthday  { 18.years.ago }
    gender { 'female' }
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end

# == Schema Information
#
# Table name: customer_users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  birthday               :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  phone_number           :string
#  post_code              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  country_id             :bigint
#
# Indexes
#
#  index_customer_users_on_country_id            (country_id)
#  index_customer_users_on_email                 (email) UNIQUE
#  index_customer_users_on_reset_password_token  (reset_password_token) UNIQUE
#
