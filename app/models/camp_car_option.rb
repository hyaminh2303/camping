class CampCarOption < ApplicationRecord
  include SupplierCompanyAsTenant

  has_and_belongs_to_many :camp_cars

  translates :name
  globalize_accessors locales: I18n.available_locales, attributes: [:name]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates :name, uniqueness: { scope: :supplier_company_id }
  validates :fee_per_day, :name, presence: true
  validates :fee_per_day, numericality: { greater_than_or_equal_to: 0 }
  # Add all your validations before
  validate :validates_globalized_attributes

end

# == Schema Information
#
# Table name: camp_car_options
#
#  id                  :bigint           not null, primary key
#  fee_per_day         :integer
#  name                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  camp_car_option_id  :bigint           not null
#  supplier_company_id :integer
#
