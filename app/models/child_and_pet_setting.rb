class ChildAndPetSetting < ApplicationRecord
  has_many :child_and_pet_fees, dependent: :destroy
  has_many :child_and_pet_entrance_fees, dependent: :destroy

  belongs_to :campsite

  translates :entity_label
  globalize_accessors locales: I18n.available_locales, attributes: [:entity_label]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  enum entity_type: [:child, :pet]

  validates :entity_type, :entity_label, :campsite_id, presence: true
  # Add all your validations before
  validate :validates_globalized_attributes

  scope :by_campsite_id, -> (campsite_ids) {
    where(campsite_id: campsite_ids)
  }

  def cache_key
    super + '-' + Globalize.locale.to_s
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
