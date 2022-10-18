FactoryBot.define do
  factory :camp_car_option do
    name { "MyString" }
    fee_per_day { "9.99" }
  end
end

# == Schema Information
#
# Table name: camp_car_options
#
#  id                  :bigint           not null, primary key
#  fee_per_day         :integer
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  camp_car_option_id  :bigint           not null
#  supplier_company_id :integer
#
