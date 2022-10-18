class CampsitePlanQuantityCalculationService
  attr_accessor :campsite_plan
  attr_reader :customer_user, :params, :session

  def initialize(params, customer_user=nil, session={})
    @params = params
    @customer_user = customer_user
    @session = session
  end

  def is_campsite_plan_out_of_stock?
    travel_package = TravelPackage.find_by(id: params[:travel_package_id])
    check_in = (params[:check_in] || params[:travel_package]&.dig(:campsite_booking_attributes, :check_in))&.in_time_zone&.to_date
    check_out = (params[:check_out] || params[:travel_package]&.dig(:campsite_booking_attributes, :check_out))&.in_time_zone&.to_date
    # In case edit booking from my page or on the admin side(use to show/hide button)
    if travel_package&.status_booked? && travel_package.check_in == check_in && travel_package.check_out == check_out
      false
    else
      set_campsite_plan_attributes
      @campsite_plan.is_campsite_plan_out_of_stock?(@check_in, @check_out)
    end
  end

  private

  def set_campsite_plan_attributes
    # Check remaining quantity on the campsite plan page, step 4 of booking(confirm_information),
    # change date input on admin side, step 5 of booking(payment with credit card and incomplete status)
    if params[:campsite_plan_id].present? && params[:check_in].present? && params[:check_out].present?
      @campsite_plan = CampsitePlan.find(params[:campsite_plan_id])
      @check_in = params[:check_in].in_time_zone.to_date
      @check_out = params[:check_out].in_time_zone.to_date
    # Step 1,2 of booking(select_people_and_date, select_plan_options)
    elsif session[:travel_package_of_campsite_booking_draft]&.dig('campsite_booking').present?
      campsite_booking = session[:travel_package_of_campsite_booking_draft].dig('campsite_booking')
      @campsite_plan = CampsitePlan.find_by(id: campsite_booking['campsite_plan_id'])
      @check_in = campsite_booking['check_in'].in_time_zone.to_date
      @check_out = campsite_booking['check_out'].in_time_zone.to_date
    # Step 3, 4 of booking(contact_information, confirm_information)
    elsif customer_user&.current_travel_package_of_campsite_booking.present?
      travel_package = customer_user.current_travel_package_of_campsite_booking
      campsite_booking = travel_package.campsite_booking
      @campsite_plan = campsite_booking.campsite_plan
      @check_in = campsite_booking.check_in.in_time_zone.to_date
      @check_out = campsite_booking.check_out.in_time_zone.to_date
    # For creating or updating on admin side
    elsif params[:travel_package]&.dig(:campsite_booking_attributes).present?
      campsite_booking_attributes = params[:travel_package].dig(:campsite_booking_attributes)
      @campsite_plan = CampsitePlan.find(campsite_booking_attributes[:campsite_plan_id])
      @check_in = campsite_booking_attributes[:check_in].in_time_zone.to_date
      @check_out = campsite_booking_attributes[:check_out].in_time_zone.to_date
    end
  end
end