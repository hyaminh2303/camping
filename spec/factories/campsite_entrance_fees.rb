FactoryBot.define do
  factory :campsite_entrance_fee do
    adult_fee { "9.99" }
  end
end

# == Schema Information
#
# Table name: campsite_entrance_fees
#
#  id          :bigint           not null, primary key
#  adult_fee   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  campsite_id :integer
#
