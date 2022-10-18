FactoryBot.define do
  factory :child_and_pet_setting do
    entity_type { 1 }
    entity_label { "MyString" }
  end
end

# == Schema Information
#
# Table name: child_and_pet_settings
#
#  id                       :bigint           not null, primary key
#  entity_label             :string
#  entity_type              :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  campsite_id              :bigint
#  child_and_pet_setting_id :bigint           not null
#
# Indexes
#
#  index_child_and_pet_settings_on_campsite_id  (campsite_id)
#
