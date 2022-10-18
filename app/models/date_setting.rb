class DateSetting < ApplicationRecord
  DAY_NAME = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

  belongs_to :classification_day_setting, optional: true

  belongs_to :campsite

  validates :date, presence: true
  validates :date, uniqueness: { scope: :campsite_id }

  scope :by_campsite_id, -> (campsite_id) {
    where(campsite_id: campsite_id)
  }

end

# == Schema Information
#
# Table name: date_settings
#
#  id                            :bigint           not null, primary key
#  date                          :date
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  campsite_id                   :bigint
#  classification_day_setting_id :bigint
#
# Indexes
#
#  index_date_settings_on_campsite_id                    (campsite_id)
#  index_date_settings_on_classification_day_setting_id  (classification_day_setting_id)
#
