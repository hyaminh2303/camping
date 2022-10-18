FactoryBot.define do
  factory :date_setting do
    date { "2021-10-02" }
    classification_day_setting { nil }
  end
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
