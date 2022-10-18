class CampCategory < ApplicationRecord
  belongs_to :camp_category_group
  has_many :campsite_camp_categories, dependent: :destroy
  has_many :campsites, through: :campsite_camp_categories

  translates :name
  globalize_accessors locales: I18n.available_locales, attributes: [:name]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates :name, presence: true
  validates :weight, uniqueness: { scope: :camp_category_group }, if: proc { weight.present? }
  # Add all your validations before
  validate :validates_globalized_attributes

  scope :by_id, -> (ids) { where(id: ids) }
  scope :with_camp_category_group_translations, -> (locale) {
    includes(camp_category_group: :translations).where(camp_category_group_translations: {locale: locale})
  }
  scope :order_by_weight_asc, -> { order(weight: :asc) }

end

# == Schema Information
#
# Table name: camp_categories
#
#  id                     :bigint           not null, primary key
#  name                   :string
#  weight                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  camp_category_group_id :bigint
#  camp_category_id       :bigint           not null
#
# Indexes
#
#  index_camp_categories_on_camp_category_group_id  (camp_category_group_id)
#
