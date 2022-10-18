FactoryBot.define do
  factory :campsite_plan_daily_fee_setting do
    campsite_plan_id { 1 }
    basic_fee { "9.99" }
    number_of_people_pet_included { 1 }
    extra_person_fee { "9.99" }
  end
end

# == Schema Information
#
# Table name: campsite_plan_daily_fee_settings
#
#  id                            :bigint           not null, primary key
#  basic_fee                     :integer
#  date                          :date
#  extra_person_fee              :integer
#  number_of_people_pet_included :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  campsite_plan_id              :integer
#
