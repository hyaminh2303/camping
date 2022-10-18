class CampsitePlansController < ApplicationController
  def show
    session.delete(:travel_package_of_campsite_booking_draft)

    @campsite_plan = CampsitePlan.find(params[:id])
    campsite_booking_service = CampsiteBookingService.new(CustomerUser.new, params)
    @travel_package = campsite_booking_service.init_travel_package
  end

  def calculate_price
    travel_package = TravelPackage.new()
    travel_package.assign_attributes(travel_package_params)
    campsite_booking = travel_package.campsite_booking
    campsite_plan_is_included_entrance_fee = campsite_booking.campsite_plan.is_included_entrance_fee

    booking_price_service = CampsiteBookingPriceCalculationService.new(
      campsite_booking,
      with_entrance_fee: !campsite_plan_is_included_entrance_fee
    )
    travel_package.total_price = booking_price_service.calculate

    travel_package_serializable = TravelPackageSerializer.new(travel_package).serializable_hash(include: '**')
    set_travel_package_of_campsite_booking_draft(travel_package_serializable)

    render json: travel_package_serializable
  end

  def check_remaining_quantity
    campsite_plan_quantity_calculation_service = CampsitePlanQuantityCalculationService.new(
      params, current_customer_user)

    result = campsite_plan_quantity_calculation_service.is_campsite_plan_out_of_stock?

    render json: {is_campsite_plan_out_of_stock: result}
  end

  private

  def set_travel_package_of_campsite_booking_draft(travel_package_serializable)
    session[:travel_package_of_campsite_booking_draft] = travel_package_serializable
  end

  def travel_package_params
    permitted_params = params.require(:travel_package).permit(
      campsite_booking_attributes: [
        :campsite_plan_id, :check_in, :check_out, :number_of_adult,
        child_and_pet_included_in_bookings_attributes: [
          :child_and_pet_setting_id,
          :entity_label,
          :entity_type,
          :quantity
        ],
        campsite_options_included_in_booking_attributes: [
          :campsite_plan_option_id,
          :quantity,
          :name
        ]
      ],
    )
  end

end