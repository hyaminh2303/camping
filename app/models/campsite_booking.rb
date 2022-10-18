class CampsiteBooking < ApplicationRecord
  include SupplierCompanyAsTenant

  MIN_NUMBER_OF_ADULT = 1
  MAX_NUMBER_OF_ADULT = 10000

  belongs_to :travel_package, dependent: :destroy, inverse_of: :campsite_booking
  belongs_to :campsite_plan
  has_many :child_and_pet_included_in_bookings, dependent: :destroy, inverse_of: :campsite_booking
  has_many :campsite_options_included_in_booking, dependent: :destroy, inverse_of: :campsite_booking
  has_many :booking_messages, as: :booking_messageable, dependent: :destroy
  has_one :campsite, through: :campsite_plan

  accepts_nested_attributes_for :child_and_pet_included_in_bookings, allow_destroy: :true
  accepts_nested_attributes_for :campsite_options_included_in_booking, allow_destroy: :true
  accepts_nested_attributes_for :travel_package, reject_if: :all_blank
  accepts_nested_attributes_for :campsite_plan, reject_if: :all_blank
  accepts_nested_attributes_for :booking_messages, allow_destroy: :true, reject_if: :reject_booking_messages

  validates :check_in, :check_out, presence: true
  validates_date :check_in, on_or_after: -> { Date.current + 1.day}
  validates_date :check_out, after: :check_in
  validates_numericality_of :number_of_adult, greater_than_or_equal_to: MIN_NUMBER_OF_ADULT, less_than_or_equal_to: MAX_NUMBER_OF_ADULT
  validate :check_the_max_number_of_people

  before_validation :set_supplier_company_id

  scope :in_card_validation_time, -> () {
    where('check_in <= ?::date', PaymentProcessor::NUMBER_OF_DAY_FOR_TEMPORARY_SALE.days.from_now.end_of_day)
  }

  scope :without_incomplete_booking, -> {
    includes(travel_package: :booking_contact_information, campsite_plan: :campsite).where.not(
      travel_packages: { status: :incomplete }
    )
  }
  scope :with_travel_package, ->(travel_package_ids) { where(travel_package_id: travel_package_ids) }
  scope :by_user_booking, -> {
    includes(:travel_package).where(
      travel_packages: { booked_by_type: "CustomerUser" }
    )
  }
  scope :by_campsite_plans, -> (campsite_plan_ids) { where(campsite_plan_id: campsite_plan_ids) }
  scope :by_campsite, -> (campsite_id) { joins(:campsite).where('campsites.id = ?', campsite_id) }
  scope :by_date, -> (date) {where('check_in <= ? AND check_out >= ?', date.in_time_zone, date.in_time_zone)}
  scope :start_from_date_to_date, -> (date_from, date_to) { where('check_in >= ? AND check_in <= ?', date_from.in_time_zone, date_to.in_time_zone) }
  scope :by_check_in, -> (date) {where(check_in: date.in_time_zone)}
  scope :by_check_out, -> (date) {where(check_out: date.in_time_zone)}
  scope :only_booked_status, -> () {
    includes(:travel_package).where(travel_package: { status: :booked })
  }
  scope :with_start_date_and_end_date, -> (start_date, end_date) {
    where('check_in <= ? AND check_out >= ?', start_date, end_date)
  }
  scope :by_month_check_in, -> (month) { where("extract(month from check_in) = ?", month) }
  scope :by_year_check_in, -> (year) { where("extract(year from check_in) = ?", year) }

  ransacker :check_in_start, type: :date do |parent|
    Arel.sql("DATE(check_in)")
  end

  ransacker :check_in_end, type: :date do |parent|
    Arel.sql("DATE(check_in)")
  end

  def number_of_nights
    ((self.check_out - self.check_in)  / 1.day).floor
  end

  def number_of_children
    self.child_and_pet_included_in_bookings.map do |child_and_pet_included_in_booking|
      child_and_pet_included_in_booking.quantity.to_i if child_and_pet_included_in_booking.child?
    end.compact.sum
  end

  def number_of_pet
    self.child_and_pet_included_in_bookings.map do |child_and_pet_included_in_booking|
      child_and_pet_included_in_booking.quantity.to_i if child_and_pet_included_in_booking.pet?
    end.compact.sum
  end

  def number_of_children_and_pet
    self.child_and_pet_included_in_bookings.map do |child_and_pet_included_in_booking|
      child_and_pet_included_in_booking.quantity.to_i
    end.sum
  end

  def number_of_people
    number_of_adult.to_i + number_of_children
  end

  def is_booking_till_3_days_before_check_in_date?
    self.check_in > PaymentProcessor::NUMBER_OF_DAY_FOR_ACTUAL_SALE.days.from_now.end_of_day
  end

  def is_booking_in_the_past?
    self.check_in.to_date < Date.current
  end

  def is_more_than_the_number_of_people_allowed?
    number_of_people > self.campsite_plan.max_number_of_people
  end

  def item
    campsite_plan.campsite
  end

  def has_error_on_remaining_options_stock?
    errors.has_key? :"campsite_options_included_in_booking.quantity"
  end

  private

  def set_supplier_company_id
    self.supplier_company_id = campsite_plan.campsite.supplier_company_id
  end

  def check_the_max_number_of_people
    if is_more_than_the_number_of_people_allowed?
      self.errors.add(:max_number_of_people, I18n.t('checkout.campsite_bookings.error_messages.error_max_number_of_people'))
    end
  end

  # https://app.clickup.com/t/2ew3bu5
  def reject_booking_messages(attrs)
    booking_message_details = attrs.dig(:booking_message_details_attributes)&.values

    return true if booking_message_details.blank? || booking_message_details.first.dig(:message).blank?

    false
  end

end

# == Schema Information
#
# Table name: campsite_bookings
#
#  id                  :bigint           not null, primary key
#  check_in            :datetime
#  check_out           :datetime
#  note                :text
#  number_of_adult     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  campsite_plan_id    :bigint
#  supplier_company_id :bigint
#  travel_package_id   :bigint
#
# Indexes
#
#  index_campsite_bookings_on_campsite_plan_id     (campsite_plan_id)
#  index_campsite_bookings_on_supplier_company_id  (supplier_company_id)
#  index_campsite_bookings_on_travel_package_id    (travel_package_id)
#
