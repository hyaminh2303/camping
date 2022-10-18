class CampCarQuantityCalculationService
  attr_accessor :camp_car
  attr_reader :customer_user, :params, :session

  def initialize(params, customer_user=nil, session={})
    @params = params
    @customer_user = customer_user
    @session = session
  end

  def is_camp_car_out_of_stock?
    travel_package = TravelPackage.find_by(id: params[:travel_package_id])
    check_in = (params[:check_in] || params[:travel_package]&.dig(:camp_car_booking_attributes, :start_date_of_renting))&.in_time_zone&.to_date
    check_out = (params[:check_out] || params[:travel_package]&.dig(:camp_car_booking_attributes, :end_date_of_renting))&.in_time_zone&.to_date
    # In case edit booking from my page or on the admin side(use to show/hide button)
    if travel_package&.status_booked? && travel_package.check_in == check_in && travel_package.check_out == check_out
      false
    else
      set_camp_car_attributes
      @camp_car.is_camp_car_out_of_stock?(@check_in, @check_out)
    end
  end

  private

  def set_camp_car_attributes
    # Check remaining quantity on the camp car page, step 4 of booking(confirm_information),
    # change date input on admin side, step 5 of booking(payment with credit card and incomplete status)
    if params[:camp_car_id].present? && params[:check_in].present? && params[:check_out].present?
      @camp_car = CampCar.find(params[:camp_car_id])
      @check_in = params[:check_in].in_time_zone.to_date
      @check_out = params[:check_out].in_time_zone.to_date
    # Step 1,2 of booking(select_people_and_date, select_plan_options)
    elsif session[:travel_package_of_camp_car_booking_draft]&.dig('camp_car_booking').present?
      camp_car_booking = session[:travel_package_of_camp_car_booking_draft].dig('camp_car_booking')
      @camp_car = CampCar.find_by(id: camp_car_booking['camp_car_id'])
      @check_in = camp_car_booking['start_date_of_renting'].in_time_zone.to_date
      @check_out = camp_car_booking['end_date_of_renting'].in_time_zone.to_date
    # Step 3, 4 of booking(contact_information, confirm_information)
    elsif customer_user&.current_travel_package_of_camp_car_booking.present?
      travel_package = customer_user.current_travel_package_of_camp_car_booking
      camp_car_booking = travel_package.camp_car_booking
      @camp_car = camp_car_booking.camp_car
      @check_in = camp_car_booking.start_date_of_renting.in_time_zone.to_date
      @check_out = camp_car_booking.end_date_of_renting.in_time_zone.to_date
    # For creating or updating on admin side
    elsif params[:travel_package]&.dig(:camp_car_booking_attributes).present?
      camp_car_booking_attributes = params[:travel_package].dig(:camp_car_booking_attributes)
      @camp_car = CampCar.find(camp_car_booking_attributes[:camp_car_id])
      @check_in = camp_car_booking_attributes[:check_in].in_time_zone.to_date
      @check_out = camp_car_booking_attributes[:check_out].in_time_zone.to_date
    end
  end
end