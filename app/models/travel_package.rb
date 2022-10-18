class TravelPackage < ApplicationRecord
  extend Enumerize
  belongs_to :customer_user, optional: true
  has_one :campsite_booking, dependent: :destroy, inverse_of: :travel_package
  has_one :camp_car_booking, dependent: :destroy, inverse_of: :travel_package
  has_one :booking_contact_information, dependent: :destroy
  has_one :gmo_transaction, dependent: :destroy
  belongs_to :canceled_by, polymorphic: true, optional: true
  belongs_to :booked_by, polymorphic: true

  accepts_nested_attributes_for :campsite_booking
  accepts_nested_attributes_for :camp_car_booking
  accepts_nested_attributes_for :booking_contact_information, reject_if: :all_blank


  enumerize :booking_type,
            in: [:campsite_booking, :camp_car_booking, :tour_booking],
            predicates: { prefix: true },
            scope: true

  enumerize :status,
            in: [:incomplete, :booked, :canceled, :check_out, :no_show],
            predicates: { prefix: true },
            scope: true,
            i18n_scope: 'activerecord.enum.travel_package.status'

  enumerize :payment_method,
            in: [:credit_card, :cash],
            predicates: { prefix: true },
            scope: true,
            i18n_scope: 'activerecord.enum.travel_package.payment_method'

  # validates :customer_user_id, presence: true, if: proc { self.status_booked? || self.status_canceled? }
  validates :booking_type, :payment_method, presence: true
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  scope :without_gmo_transaction, -> () {
    gmo_transactions = GmoTransaction.all
    where.not(id: gmo_transactions.pluck(:travel_package_id))
  }
  scope :by_ids, -> (ids) {where(id: ids)}
  scope :without_adding_credit_card_reminder, -> () { where(is_adding_credit_card_reminder_sent: false) }

  scope :by_user, -> {where(booked_by_type: "CustomerUser")}
  scope :by_admin, -> {where(booked_by_type: "AdminUser")}

  scope :with_booking_inside, ->{where(is_booking_outside: false)}

  after_create do
    self.booking_ref_number = "#{Date.current.year}#{self.id}"
    self.save
  end

  def order_id
    prefix = {
      campsite_booking: 'CS',
      camp_car_booking: 'CC',
      tour_booking: 'T',
    }[booking_type.to_sym]

    "#{prefix}#{id}#{Rails.env.first.upcase}#{created_at.strftime('%Y%m%d')}"
  end

  def processed_total_price
    total_price.to_i
  end

  def mark_status_as_booked
    update(status: :booked)
  end

  def booking
    self.send("#{self.booking_type}")
  end

  def is_editable?
    # never be able edit for booking canceled
    return false if status_canceled?
    # never be able to edit or cancel a booking in the past
    return false if booking.is_booking_in_the_past?

    # Condition 2: If payment is Card (contract type is commission) ==> can NOT see EDIT booking button
    return false if payment_method_credit_card?

    return true if payment_method_cash?

    return false
  end

  def is_cancelable?
    # never be able to edit or cancel a booking in the past
    return false if status_canceled?
    return false if booking.is_booking_in_the_past?

    return true if payment_method_cash?

    return true if payment_method_credit_card? && is_check_in_date_started_from_1_day? # https://app.clickup.com/t/232e2nd

    return false
  end

  def is_check_in_date_started_from_3_days?
    is_check_in_date_started_from_3_days_to_60_days_from_now? ||
    is_check_in_date_started_after_60_days_from_now?
  end

  # example of requirement
  # if today is 1st Jan, then three days from now will 1st, 2nd and 3rd
  def is_check_in_date_started_within_3_days_from_now?
    if booking_type_campsite_booking?
      campsite_booking.check_in < 3.days.from_now.beginning_of_day

    elsif booking_type_camp_car_booking?
      camp_car_booking.start_date_of_renting < 3.days.from_now.beginning_of_day

    elsif booking_type_tour_booking?
      # TODO: For tour booking
    end
  end

  # example of requirement
  # if today is 1st Jan, then 3 days to 60 days from now will be from 4th Jan to 2nd Mar
  def is_check_in_date_started_from_3_days_to_60_days_from_now?
    if booking_type_campsite_booking?
      campsite_booking.check_in >= 3.days.from_now.beginning_of_day &&
      campsite_booking.check_in < 60.days.from_now.beginning_of_day

    elsif booking_type_camp_car_booking?
      camp_car_booking.start_date_of_renting >= 3.days.from_now.beginning_of_day &&
      camp_car_booking.start_date_of_renting < 60.days.from_now.beginning_of_day

    elsif booking_type_tour_booking?
      # TODO: For tour booking
    end
  end

  # example of requirement
  # if today is 1st Jan, then 60 days from now will be after 2nd Mar
  def is_check_in_date_started_after_60_days_from_now?
    if booking_type_campsite_booking?
      campsite_booking.check_in >= 60.days.from_now.beginning_of_day

    elsif booking_type_camp_car_booking?
      camp_car_booking.start_date_of_renting >= 60.days.from_now.beginning_of_day

    elsif booking_type_tour_booking?
      # TODO: For tour booking
    end
  end

  def is_check_in_date_started_from_1_day?
    check_in >= 1.day.from_now.beginning_of_day
  end

  def booking_status
    # status in: [:incomplete, :booked, :canceled, :check_out, :no_show]
    if status_booked? && (payment_method_cash? || payment_method_credit_card? && is_check_in_date_started_within_3_days_from_now?)
      # cash payment or after Actual sales transaction occur
      :booked
    elsif payment_method_credit_card? && status_booked? && is_check_in_date_started_from_3_days_to_60_days_from_now?
      # after temporary sales transaction occur
      :temporary_booked
    else
      status
    end
  end

  def check_in
    if booking_type_campsite_booking?
      campsite_booking.check_in
    elsif booking_type_camp_car_booking?
      camp_car_booking.start_date_of_renting
    else
      # TODO: tour
    end
  end

  def check_out
    if booking_type_campsite_booking?
      campsite_booking.check_out
    elsif booking_type_camp_car_booking?
      camp_car_booking.end_date_of_renting
    else
      # TODO: tour
    end
  end

  def item_name
    item.name
  end

  def item_address
    item.address
  end

  def item_phone_number
    item.contact_number
  end

  def item
    booking.item
  end

  def check_in_time
    check_in_time = if booking_type_campsite_booking?
      campsite_booking.check_in.change(hour: campsite_booking.campsite_plan.check_in_time.hour, min: campsite_booking.campsite_plan.check_out_time.min)
    elsif booking_type_camp_car_booking?
      camp_car_booking.start_date_of_renting
    else
      # TODO: tour
    end

    check_in_time
  end

  def check_out_time
    check_out_time = if booking_type_campsite_booking?
      check_out.change(hour: campsite_booking.campsite_plan.check_out_time.hour, min: campsite_booking.campsite_plan.check_out_time.min)
    elsif booking_type_camp_car_booking?
      camp_car_booking.end_date_of_renting
    else
      # TODO: tour
    end

    check_out_time
  end

  def options_included_in_booking
    if booking_type_campsite_booking?
      campsite_booking.campsite_options_included_in_booking.greater_than_zero
    elsif booking_type_camp_car_booking?
      camp_car_booking.camp_car_options_included_in_booking.greater_than_zero
    else
      # TODO: tour
    end
  end

  def plan_name
    if booking_type_campsite_booking?
      campsite_booking.campsite_plan.name
    elsif booking_type_camp_car_booking?
      camp_car_booking.camp_car.name
    else
      # TODO: tour
    end
  end

  def mailer
    if booking_type_campsite_booking?
      CampsiteBookingMailer
    elsif booking_type_camp_car_booking?
      CampCarBookingMailer
    else
      TouBookingMailer
    end
  end

end

# == Schema Information
#
# Table name: travel_packages
#
#  id                                  :bigint           not null, primary key
#  booked_by_type                      :string
#  booking_ref_number                  :string
#  booking_type                        :string
#  canceled_at                         :datetime
#  canceled_by_type                    :string
#  credit_card_addition_expired_at     :datetime
#  is_adding_credit_card_reminder_sent :boolean          default(FALSE)
#  is_booking_outside                  :boolean          default(FALSE)
#  payment_method                      :string
#  status                              :string
#  total_price                         :decimal(, )
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  booked_by_id                        :bigint
#  canceled_by_id                      :bigint
#  customer_user_id                    :bigint
#
# Indexes
#
#  index_travel_packages_on_booked_by         (booked_by_type,booked_by_id)
#  index_travel_packages_on_canceled_by       (canceled_by_type,canceled_by_id)
#  index_travel_packages_on_customer_user_id  (customer_user_id)
#
