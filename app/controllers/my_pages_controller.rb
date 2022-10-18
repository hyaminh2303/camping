class MyPagesController < BaseController
  before_action :set_travel_package, only: [:show]

  def show
    @travel_packages = current_customer_user.travel_packages.without_status(:incomplete).page(params[:page])

    get_booking_history_detail

  end

  private

  def set_travel_package
    @travel_package = current_customer_user.travel_packages.find_by(id: params[:travel_package_id])
  end

  def get_booking_history_detail
    return if @travel_package.blank?

    if @travel_package.booking_type.campsite_booking?
      @campsite_booking = @travel_package.campsite_booking
      @campsite = @campsite_booking.campsite_plan.campsite
    end

    if @travel_package.booking_type.camp_car_booking?
      @camp_car_booking = @travel_package.camp_car_booking
      @camp_car = @camp_car_booking.camp_car
    end
  end

end