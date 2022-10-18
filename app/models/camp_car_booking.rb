class CampCarBooking < ApplicationRecord
  include SupplierCompanyAsTenant

  has_many :camp_car_options_included_in_booking, dependent: :destroy, inverse_of: :camp_car_booking
  has_many :booking_messages, as: :booking_messageable, dependent: :destroy
  belongs_to :camp_car
  belongs_to :travel_package, dependent: :destroy, inverse_of: :camp_car_booking

  accepts_nested_attributes_for :camp_car_options_included_in_booking, allow_destroy: :true
  accepts_nested_attributes_for :travel_package, reject_if: :all_blank

  validates :start_date_of_renting, :end_date_of_renting, presence: true
  validates_date :start_date_of_renting, on_or_after: lambda { Date.current }
  validates_date :end_date_of_renting, after: :start_date_of_renting

  before_validation :set_supplier_company_id

  scope :by_start_date_and_end_date, -> (start_date, end_date) {
    date_range = [start_date.in_time_zone .. end_date.in_time_zone]
    where(start_date_of_renting: date_range).or(where(end_date_of_renting: date_range))
  }
  scope :by_date, -> (date) {
    where("start_date_of_renting <= ?::date AND ?::date <= end_date_of_renting", date, date)
  }

  scope :in_card_validation_time, -> () {
    where('start_date_of_renting <= ?::date', PaymentProcessor::NUMBER_OF_DAY_FOR_TEMPORARY_SALE.days.from_now.end_of_day)
  }

  scope :without_incomplete_booking, -> {
    includes(:camp_car, travel_package: :booking_contact_information).where.not(
      travel_packages: { status: :incomplete }
    )
  }

  scope :only_booked_status, -> () {
    includes(:travel_package).where(travel_package: { status: :booked })
  }

  scope :by_camp_cars, -> (camp_car_ids) { where(camp_car_id: camp_car_ids) }

  ransacker :check_in_start, type: :date do |parent|
    Arel.sql("DATE(start_date_of_renting)")
  end

  ransacker :check_in_end, type: :date do |parent|
    Arel.sql("DATE(start_date_of_renting)")
  end

  def number_of_nights
    ((self.end_date_of_renting - self.start_date_of_renting)  / 1.day).floor
  end

  def is_booking_till_3_days_before_check_in_date?
    self.start_date_of_renting > PaymentProcessor::NUMBER_OF_DAY_FOR_ACTUAL_SALE.days.from_now.end_of_day
  end

  def is_booking_in_the_past?
    self.end_date_of_renting.to_date < Date.current
  end

  def item
    camp_car
  end

  private

  def set_supplier_company_id
    self.supplier_company_id = camp_car.supplier_company_id
  end

end

# == Schema Information
#
# Table name: camp_car_bookings
#
#  id                    :bigint           not null, primary key
#  end_date_of_renting   :datetime
#  note                  :text
#  start_date_of_renting :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  camp_car_id           :bigint
#  supplier_company_id   :bigint
#  travel_package_id     :bigint
#
# Indexes
#
#  index_camp_car_bookings_on_camp_car_id          (camp_car_id)
#  index_camp_car_bookings_on_supplier_company_id  (supplier_company_id)
#  index_camp_car_bookings_on_travel_package_id    (travel_package_id)
#
