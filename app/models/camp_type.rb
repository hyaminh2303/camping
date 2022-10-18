class CampType < ApplicationRecord
  has_and_belongs_to_many :campsites

  validates :name, presence: true
  validates :name, uniqueness: true

  translates :name
  globalize_accessors locales: I18n.available_locales, attributes: [:name]
  globalize_validations locales: [:ja] # Validates only 'ja'
   # Add all your validations before
  validate :validates_globalized_attributes

end

# == Schema Information
#
# Table name: camp_types
#
#  id           :bigint           not null, primary key
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  camp_type_id :bigint           not null
#
