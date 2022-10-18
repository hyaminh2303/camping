class ClassificationDaySetting < ApplicationRecord
  has_many :date_settings, dependent: :destroy
  has_many :campsite_plan_fee_details, dependent: :destroy
  has_many :child_and_pet_fees, dependent: :destroy
  has_and_belongs_to_many :campsite_plan_fees

  scope :by_ids, -> (ids) {where(id: ids)}
end

# == Schema Information
#
# Table name: classification_day_settings
#
#  id         :bigint           not null, primary key
#  color      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
