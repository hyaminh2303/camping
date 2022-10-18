FactoryBot.define do
  factory :campsite_plan_price do
    date_range_type { 1 }
    start_date { "2021-09-04 11:44:25" }
    end_date { "2021-09-04 11:44:25" }
    price { "9.99" }
    campsite_plan_fee_id { 1 }
  end
end

# == Schema Information
#
# Table name: campsite_plan_fee_details
#
#  id                                      :bigint           not null, primary key
#  basic_fee                               :integer
#  extra_person_fee                        :integer
#  number_of_people_pet_included           :integer
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  classification_day_campsite_plan_fee_id :integer
#  classification_day_setting_id           :integer
#  normal_campsite_plan_fee_id             :integer
#
