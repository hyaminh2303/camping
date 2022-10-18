class CampCarQuantity < ApplicationRecord
  belongs_to :camp_car

  validates :date, :quantity, presence: true
  validates :date, uniqueness: { scope: :camp_car_id }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :by_date, -> (date) { where(date: date) }
  scope :by_start_date_and_end_date, ->(start_date, end_date) {where(date: [start_date..end_date])}

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
