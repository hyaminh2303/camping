class ChildAndPetIncludedInBooking < ApplicationRecord
  extend Enumerize

  MIN_NUMBER_OF_QUANTITY = 0
  MAX_NUMBER_OF_QUANTITY = 10000

  belongs_to :campsite_booking, inverse_of: :child_and_pet_included_in_bookings
  belongs_to :child_and_pet_setting

  translates :entity_label
  globalize_accessors locales: I18n.available_locales,
                      attributes: [:entity_label]

  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  enumerize :entity_type, in: [:child, :pet], scope: true, predicates: true

  validates_numericality_of :fee, greater_than_or_equal_to: 0
  validates_numericality_of :quantity, greater_than_or_equal_to: MIN_NUMBER_OF_QUANTITY, less_than_or_equal_to: MAX_NUMBER_OF_QUANTITY
  # Add all your validations before
  validate :validates_globalized_attributes
end

# == Schema Information
#
# Table name: child_and_pet_included_in_bookings
#
#  id                                   :bigint           not null, primary key
#  entity_label                         :string
#  entity_type                          :string
#  fee                                  :integer          default(0)
#  quantity                             :integer          default(0)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  campsite_booking_id                  :bigint
#  child_and_pet_included_in_booking_id :bigint           not null
#  child_and_pet_setting_id             :bigint
#
