class CampsitePlanDailyFeeSetting < ApplicationRecord
  belongs_to :campsite_plan

  validates :date, presence: true
  validates :date, uniqueness: { scope: :campsite_plan }
  validates_numericality_of :basic_fee, :extra_person_fee, :number_of_people_pet_included, greater_than_or_equal_to: 0
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
