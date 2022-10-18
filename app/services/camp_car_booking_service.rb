class CampCarBookingService
  attr_reader :booking_params, :customer_user, :travel_package_of_camp_car_booking_draft

  def initialize(customer_user, params, travel_package_of_camp_car_booking_draft: {})
    @booking_params = params
    @customer_user = customer_user
    @travel_package_of_camp_car_booking_draft = travel_package_of_camp_car_booking_draft
  end

  def init_travel_package
    start_date_of_renting = camp_car_booking_draft['start_date_of_renting']&.to_date || Date.current
    end_date_of_renting = camp_car_booking_draft['end_date_of_renting']&.to_date || Date.current + 1.day

    @travel_package = customer_user.travel_packages.build(
      status: :incomplete,
      booking_type: :camp_car_booking,
      camp_car_booking_attributes: {
        camp_car: CampCar.find(booking_params[:id]),
        start_date_of_renting: start_date_of_renting,
        end_date_of_renting: end_date_of_renting
      }
    )

    set_travel_package_payment_method
    @travel_package.total_price = camp_car_price_calculation_service.calculate
    @travel_package
  end

  def create_travel_package
    customer_user.clean_up_old_incomplete_travel_package_of_camp_car_booking
    @travel_package = customer_user.travel_packages.build(booking_params)
    set_camp_car_booking_options
    set_travel_package_payment_method
    @travel_package.total_price = camp_car_price_calculation_service.calculate
    @travel_package.save
    @travel_package
  end

  private

  def camp_car_booking_draft
    @camp_car_booking_draft ||= travel_package_of_camp_car_booking_draft.try(:[], 'camp_car_booking') || {}
  end

  def set_camp_car_booking_options
    camp_car_booking = @travel_package.camp_car_booking
    camp_car_booking.camp_car.camp_car_options.each do |camp_car_option|
      camp_car_booking.camp_car_options_included_in_booking.build(
        camp_car_option: camp_car_option,
        name: camp_car_option.name,
        fee_per_day: camp_car_option.fee_per_day
      )
    end
  end

  def camp_car_price_calculation_service
    CampCarBookingPriceCalculationService.new(@travel_package.camp_car_booking)
  end

  def set_travel_package_payment_method
    payment_method =
      if camp_car_supplier_company.contract_type_commission_base?
        :credit_card
      elsif camp_car_supplier_company.contract_type_no_commission?
        :cash
      end

    @travel_package.payment_method = payment_method
  end

  def camp_car_supplier_company
    @travel_package.camp_car_booking.camp_car.camp_car_supplier_company
  end
end
