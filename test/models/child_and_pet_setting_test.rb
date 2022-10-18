require "test_helper"

class ChildAndPetSettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
