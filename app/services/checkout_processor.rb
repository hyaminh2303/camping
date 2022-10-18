class CheckoutProcessor
  include Rails.application.routes.url_helpers

  attr_reader :customer_user, :travel_package
  attr_accessor :next_redirect_path

  def initialize(customer_user, travel_package)
    @customer_user = customer_user
    @travel_package = travel_package
  end

  def get_next_redirect_path
    if travel_package.payment_method_cash?
      travel_package.mark_status_as_booked
      travel_package.mailer.send_camp_book_confirmation_definitive_email_as_the_cash_payment_to_customer(travel_package).deliver_now
      travel_package.mailer.send_camp_book_confirmation_definitive_email_as_the_cash_payment_to_admin(travel_package).deliver_now
      set_next_redirect_path

    elsif booking_over_60_days?
      travel_package.mark_status_as_booked
      travel_package.mailer.send_temporary_sale_email_without_credit_card_to_customer(customer_user).deliver_now
      set_next_redirect_path

    else
      new_checkout_payment_path(locale: I18n.locale, booking_type: travel_package.booking_type)
    end
  end

  private

  def set_next_redirect_path
    if travel_package.booking_type_campsite_booking?
      thank_you_checkout_campsite_bookings_path(locale: I18n.locale, travel_package_id: travel_package.id)

    elsif travel_package.booking_type_camp_car_booking?
      thank_you_checkout_camp_car_bookings_path(locale: I18n.locale, travel_package_id: travel_package.id)

    elsif travel_package.booking_type_tour_booking?
      # thank_you_checkout_tour_bookings_path(travel_package_id: travel_package.id)

    end
  end

  def booking_over_60_days?
    if travel_package.booking_type_campsite_booking?
      campsite_booking_over_60_days?

    elsif travel_package.booking_type_camp_car_booking?
      camp_car_booking_over_60_days?

    elsif travel_package.booking_type_tour_booking?

    end
  end

  def campsite_booking_over_60_days?
    campsite_booking = travel_package.campsite_booking

    campsite_booking.check_in > PaymentProcessor::NUMBER_OF_DAY_FOR_TEMPORARY_SALE.days.from_now.end_of_day
  end

  def camp_car_booking_over_60_days?
    camp_car_booking = travel_package.camp_car_booking

    camp_car_booking.start_date_of_renting > PaymentProcessor::NUMBER_OF_DAY_FOR_TEMPORARY_SALE.days.from_now.end_of_day
  end

end
