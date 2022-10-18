class Master::City < ApplicationRecord
  belongs_to :prefecture
  has_many :campsites, dependent: :destroy

  translates :name
  globalize_accessors locales: I18n.available_locales, attributes: [:name]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates :name, :code, presence: true
  validates :code, uniqueness: {scope: :prefecture_id}
  # Add all your validations before
  validate :validates_globalized_attributes

  scope :by_prefecture_id, ->(prefecture_id){where(prefecture_id: prefecture_id)}
  scope :order_by_weight_asc, -> () { order(weight: :asc) }

end

# == Schema Information
#
# Table name: cities
#
#  id            :bigint           not null, primary key
#  code          :string
#  name          :string
#  weight        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  city_id       :bigint           not null
#  prefecture_id :bigint
#
# Indexes
#
#  index_cities_on_prefecture_id  (prefecture_id)
#
