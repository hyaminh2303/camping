FactoryBot.define do
  factory :classification_day_setting do
    name { "MyString" }
    color { "MyString" }
  end
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
