class Master::Prefecture < ApplicationRecord
  belongs_to :state
  has_many :cities
  has_many :campsites, dependent: :destroy
  has_many :camp_cars, dependent: :destroy

  accepts_nested_attributes_for :cities, allow_destroy: true, reject_if: :all_blank

  translates :name
  globalize_accessors locales: I18n.available_locales, attributes: [:name]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates :name, :code, presence: true
  validates :code, uniqueness: {scope: :state_id}
  # Add all your validations before
  validate :validates_globalized_attributes

  scope :by_state_id, ->(state_id){where(state_id: state_id)}
  scope :order_by_created_at, -> () { order(created_at: :asc) }
  scope :search_name_by, -> (keywords, locale = I18n.locale) {
    with_translations(locale).where('prefecture_translations.name ILIKE ?', "%#{keywords}%")
  }
end

# == Schema Information
#
# Table name: prefectures
#
#  id            :bigint           not null, primary key
#  code          :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  prefecture_id :bigint           not null
#  state_id      :bigint
#
# Indexes
#
#  index_prefectures_on_state_id  (state_id)
#
