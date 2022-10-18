FactoryBot.define do
  factory :campsite_plan_fee do
    fee_type { :normal }
    start_date { Date.current }
    end_date { Date.current + 10.days }
  end
end

# == Schema Information
#
# Table name: campsite_plan_fees
#
#  id               :bigint           not null, primary key
#  end_date         :datetime
#  fee_type         :integer
#  start_date       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  campsite_plan_id :integer
#
