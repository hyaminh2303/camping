class CampsitePlanQuantity < ApplicationRecord
  belongs_to :campsite_plan

  validates :date, presence: true
  validates :date, uniqueness: { scope: :campsite_plan_id }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :by_date, -> (date) { where(date: date) }
end

# == Schema Information
#
# Table name: campsite_plan_quantities
#
#  id               :bigint           not null, primary key
#  date             :date
#  quantity         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  campsite_plan_id :bigint
#
# Indexes
#
#  index_campsite_plan_quantities_on_campsite_plan_id  (campsite_plan_id)
#
