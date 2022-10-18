class CampsitePlan < ApplicationRecord

  I18n.available_locales.each do |locale|
    acts_as_taggable_on "tags_#{locale}"
  end

  belongs_to :campsite
  has_one :campsite_plan_fee, dependent: :destroy
  has_many :photos, as: :photoable, dependent: :destroy
  has_many :campsite_plan_daily_fee_settings, dependent: :destroy
  has_many :campsite_bookings, dependent: :destroy
  has_many :campsite_plan_quantities, dependent: :destroy

  has_and_belongs_to_many :campsite_plan_options

  translates :name, :description, :subtitle
  globalize_accessors locales: I18n.available_locales, attributes: [:name, :description, :subtitle]
  globalize_validations locales: [:ja] # Validates only 'ja' locale | https://app.clickup.com/t/1rpetz0

  accepts_nested_attributes_for :campsite_plan_fee, allow_destroy: true
  accepts_nested_attributes_for :campsite_plan_daily_fee_settings, allow_destroy: true
  accepts_nested_attributes_for :photos, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :campsite_plan_quantities, reject_if: :all_blank, allow_destroy: true

  validates_associated :campsite_plan_fee
  validates :check_in_time, :check_out_time, :max_number_of_people, :name, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  # Add all your validations before
  validate :validates_globalized_attributes

  scope :public_plans, -> { where(public_info: true) }
  scope :by_id, -> (ids) { where(id: ids) }
  scope :by_campsite_ids, -> (campsite_ids) { where(campsite_id: campsite_ids) }
  scope :with_campsite_translations, -> (locale) {
    includes(campsite: :translations).where(campsite_translations: {locale: locale})
  }

  def remaining_quantity(date, check_in, check_out)
    # In this case, if the records are too big to load into RAM, we will use SQL query for DB
    campsite_plan_quantity = self.campsite_plan_quantities.find_by(date: date)&.quantity || self.quantity

    # Example: campsite plan(check_in_time: 13:00, check_out_time: 11:00, default_quantity: 1),
    #          booking (check_in: 02/01/2022, check_out: 03/01/2022)
    # ==> Can create booking with check_in: 01/01/2022, check_out: 02/01/2022 and
    #     booking with check_in: 03/01/2022, check_out: 04/01/2022
    number_of_bookings = self.campsite_bookings.only_booked_status.by_date(date).count
    check_in_of_campsite_plan = '01/01/2000'.in_time_zone.change(hour: check_in_time.hour, min: check_in_time.min)
    check_out_of_campsite_plan = '01/01/2000'.in_time_zone.change(hour: check_out_time.hour, min: check_out_time.min)

    if check_in == date && check_in_of_campsite_plan >= check_out_of_campsite_plan
      number_of_bookings -= self.campsite_bookings.only_booked_status.by_check_out(date).count
    elsif check_out == date && check_in_of_campsite_plan >= check_out_of_campsite_plan
      number_of_bookings -= self.campsite_bookings.only_booked_status.by_check_in(date).count
    end

    campsite_plan_quantity - number_of_bookings
  end

  def is_campsite_plan_out_of_stock?(check_in, check_out)
    (check_in..check_out).each do |date|
      return true if remaining_quantity(date, check_in, check_out) <= 0
    end

    return false
  end

  def self.available_in_date_range(check_in, check_out)
    campsite_plans = all

    campsite_plan_ids = campsite_plans.ids
    (check_in..check_out).each do |date|
      campsite_plans.each do |campsite_plan|
        if campsite_plan.remaining_quantity(date, check_in, check_out) < 1
          campsite_plan_ids.delete(campsite_plan.id)
        end
      end
    end

    campsite_plans = campsite_plans.where(id: campsite_plan_ids)

    campsite_plans
  end

  def tags_locale_list
    send "tags_#{I18n.locale}_list"
  end

end

# == Schema Information
#
# Table name: campsite_plans
#
#  id                       :bigint           not null, primary key
#  check_in_time            :time
#  check_out_time           :time
#  description              :text
#  is_included_entrance_fee :boolean          default(TRUE)
#  max_number_of_people     :integer
#  name                     :string
#  people_type              :integer
#  public_info              :boolean
#  publication_period       :string
#  quantity                 :integer
#  subtitle                 :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  campsite_id              :integer
#  campsite_plan_id         :bigint           not null
#
