class CampsitePlanOption < ApplicationRecord
  MAX_NUMBER_OF_PRICE = 1000000000
  MAX_NUMBER_OF_QUANTITY = 1000000

  has_and_belongs_to_many :campsite_plans
  belongs_to :campsite

  translates :name
  globalize_accessors locales: I18n.available_locales, attributes: [:name]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates :name, :campsite_id, presence: true
  validates :name, uniqueness: { scope: :campsite }
  validates :price, :quantity, numericality: { greater_than_or_equal_to: 0 }
  # Add all your validations before
  validate :validates_globalized_attributes

  scope :by_campsite_id, -> (campsite_ids) {
    where(campsite_id: campsite_ids)
  }

  before_update do
    if self.campsite_id_was != self.campsite_id
      self.campsite_plans = []
    end
  end

end

# == Schema Information
#
# Table name: campsite_plan_options
#
#  id                      :bigint           not null, primary key
#  name                    :string
#  price                   :integer
#  quantity                :integer          default(0)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  campsite_id             :bigint
#  campsite_plan_option_id :bigint           not null
#
# Indexes
#
#  index_campsite_plan_options_on_campsite_id  (campsite_id)
#
