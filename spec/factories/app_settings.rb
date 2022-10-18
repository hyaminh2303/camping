FactoryBot.define do
  factory :app_setting do
    purchasing { 1 }
    introducing { 1 }
    weight_log { 1 }
    body_temperature_log { 1 }
    sleep_log { 1 }
    meal_log { 1 }
    bowel_log { 1 }
    women_period_log { 1 }
    register { 1 }
    seminar { "" }
    continuous_bonus { 1 }
    health_quiz { 1 }
  end
end

# == Schema Information
#
# Table name: app_settings
#
#  id                             :bigint           not null, primary key
#  camp_car_commission_percentage :float            default(23.5)
#  campsite_commission_percentage :float            default(10.5)
#  publication_fee                :integer          default(5000)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
