class CampsiteOptionIncludedInBooking < ApplicationRecord
  self.table_name = 'campsite_options_included_in_booking'

  MIN_NUMBER_OF_QUANTITY = 0

  belongs_to :campsite_plan_option
  belongs_to :campsite_booking

  translates :name, foreign_key: :campsite_option_included_in_booking_id
  globalize_accessors locales: I18n.available_locales,
                      attributes: [:name]

  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates_numericality_of :price, greater_than_or_equal_to: 0
  validates_numericality_of :quantity, greater_than_or_equal_to: MIN_NUMBER_OF_QUANTITY
  # Add all your validations before
  validate :quantity_less_than_or_equal_to_remaining_stock
  validate :validates_globalized_attributes

  scope :greater_than_zero, -> { where('quantity > 0') }

  def total_fee
    self.price * self.quantity
  end

  private

  def quantity_less_than_or_equal_to_remaining_stock
    if self.campsite_plan_option.quantity < self.quantity
      self.errors.add :quantity, :less_than_or_equal_to
    end
  end
end

# == Schema Information
#
# Table name: campsite_options_included_in_booking
#
#  id                                     :bigint           not null, primary key
#  name                                   :string
#  price                                  :integer
#  quantity                               :integer          default(0)
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  campsite_booking_id                    :bigint
#  campsite_option_included_in_booking_id :bigint           not null
#  campsite_plan_option_id                :bigint
#
