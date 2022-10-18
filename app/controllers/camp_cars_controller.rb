class CampCarsController < ApplicationController
  include ComingSoon

  before_action :render_coming_soon

  def index
    @recommended_camp_cars = RecommendedCampItem.order_by(:camp_car, :asc).map(&:recommended_itemable)
    @blog_categories = BlogCategory.all
  end

  def search
    @camp_car_search_service = CampCarSearchService.new(params)
    @camp_cars = @camp_car_search_service.run.page(params[:page])
  end

  def calculate_price
    travel_package = TravelPackage.new()
    travel_package.assign_attributes(travel_package_params)
    booking_price_service = CampCarBookingPriceCalculationService.new(travel_package.camp_car_booking)
    travel_package.total_price = booking_price_service.calculate

    travel_package_serializable = TravelPackageSerializer.new(travel_package).serializable_hash(include: '**')
    set_travel_package_of_camp_car_booking_draft(travel_package_serializable)

    render json: travel_package_serializable
  end

  def show
    session.delete(:travel_package_of_camp_car_booking_draft)

    @camp_car = CampCar.find(params[:id])
    @notice = @camp_car.notice

    camp_car_booking_service = CampCarBookingService.new(CustomerUser.new, params)
    @travel_package = camp_car_booking_service.init_travel_package
  end

  def check_remaining_quantity
    camp_car_quantity_calculation_service = CampCarQuantityCalculationService.new(
      params, current_customer_user)

    result = camp_car_quantity_calculation_service.is_camp_car_out_of_stock?

    render json: {is_camp_car_out_of_stock: result}
  end

  private

  def set_travel_package_of_camp_car_booking_draft(travel_package_serializable)
    session[:travel_package_of_camp_car_booking_draft] = travel_package_serializable
  end

  def travel_package_params
    permitted_params = params.require(:travel_package).permit(
      camp_car_booking_attributes: [
        :id, :camp_car_id, :start_date_of_renting, :end_date_of_renting,
      ],
    )
  end
end
