FactoryBot.define do
  factory :camp_car_quantity do
    date { "2021-11-08" }
    quantity { 1 }
  end
end

# == Schema Information
#
# Table name: camp_car_quantities
#
#  id          :bigint           not null, primary key
#  date        :date
#  quantity    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  camp_car_id :bigint
#
# Indexes
#
#  index_camp_car_quantities_on_camp_car_id  (camp_car_id)
#
