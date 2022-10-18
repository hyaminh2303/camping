class CampCarCategory < ApplicationRecord
  belongs_to :pick_up_drop_off_place, class_name: 'Master::City'
  has_many :camp_cars, foreign_key: :category_id, dependent: :destroy

  translates :model
  globalize_accessors locales: I18n.available_locales, attributes: [:model]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates :model, :seats, :pick_up_drop_off_place_id, presence: true
  validates :seats, numericality: { greater_than_or_equal_to: 0 }
  # Add all your validations before
  validate :validates_globalized_attributes

end

# == Schema Information
#
# Table name: camp_car_categories
#
#  id                        :bigint           not null, primary key
#  model                     :string
#  seats                     :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  camp_car_category_id      :bigint           not null
#  pick_up_drop_off_place_id :bigint
#
# Indexes
#
#  index_camp_car_categories_on_pick_up_drop_off_place_id  (pick_up_drop_off_place_id)
#
