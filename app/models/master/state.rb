class Master::State < ApplicationRecord
  has_many :prefectures
  has_many :campsites, dependent: :destroy
  has_many :camp_cars, dependent: :destroy

  accepts_nested_attributes_for :prefectures, allow_destroy: true, reject_if: :all_blank

  translates :name
  globalize_accessors locales: I18n.available_locales, attributes: [:name]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates :name, :code, presence: true
  validates :code, uniqueness: true
  # Add all your validations before
  validate :validates_globalized_attributes

  scope :order_by_weight_asc, -> () { order(weight: :asc) }

end

# == Schema Information
#
# Table name: states
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  weight     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :bigint           not null
#
