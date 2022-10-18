class CampCategoryGroup < ApplicationRecord
  has_many :camp_categories, dependent: :destroy

  translates :name
  globalize_accessors locales: I18n.available_locales, attributes: [:name]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  validates :name, presence: true
  validates :weight, uniqueness: true
  validate :only_accept_one_facility_type
  validate :only_accept_one_facility_in_the_hall
  validate :ensure_do_not_select_both
  # Add all your validations before
  validate :validates_globalized_attributes

  scope :except_facility_type, -> () { where(is_facility_type: false) }

  scope :order_by_weight_asc, -> { order(weight: :asc) }

  scope :showed_on_the_front_end, -> { where(is_shown_on_the_front_end: true) }

  scope :except_facility_in_the_hall, -> { where(is_the_facility_in_the_hall: false) }

  def self.facility_type_plan
    find_by(is_facility_type: true)
  end

  def self.with_the_facility_in_the_hall
    find_by(is_the_facility_in_the_hall: true)
  end

  private

  def only_accept_one_facility_type
    if is_facility_type && self.class.where(is_facility_type: true).where.not(id: id).count > 0
      self.errors.add(:is_facility_type, :already_exists)
    end
  end

  def only_accept_one_facility_in_the_hall
    if is_the_facility_in_the_hall && self.class.where(is_the_facility_in_the_hall: true).where.not(id: id).count > 0
      self.errors.add(:is_the_facility_in_the_hall, :already_exists)
    end
  end

  def ensure_do_not_select_both
    if is_facility_type && is_the_facility_in_the_hall
      self.errors.add(:is_the_facility_in_the_hall, :can_not_select_both)
    end
  end

end

# == Schema Information
#
# Table name: camp_category_groups
#
#  id                          :bigint           not null, primary key
#  is_facility_type            :boolean          default(FALSE)
#  is_shown_on_the_front_end   :boolean          default(TRUE)
#  is_the_facility_in_the_hall :boolean          default(FALSE)
#  name                        :string
#  weight                      :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  camp_category_group_id      :bigint           not null
#
