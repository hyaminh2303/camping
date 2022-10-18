class TravelPackagesController < BaseController
  before_action :set_travel_package, only: [:show, :update_status, :cancel]

  def show
    # if @travel_package.booking_type.campsite_booking?
    #   @campsite_booking = @travel_package.campsite_booking
    #   @campsite = @campsite_booking.campsite_plan.campsite
    # end

    # if @travel_package.booking_type.camp_car_booking?
    #   @camp_car_booking = @travel_package.camp_car_booking
    #   @camp_car = @camp_car_booking.camp_car
    # end

  end

  def update_status
    @travel_package.update(travel_package_params)

    if !@travel_package.status_canceled?
      @travel_package.update(canceled_at: nil, canceled_by: nil)
    end

    redirect_back(fallback_location: root_path)
  end

  def cancel
    cancellation_service = TravelPackageCancellationService.new(@travel_package, canceled_by: current_customer_user)
    cancellation_service.run
    redirect_back(fallback_location: root_path, alert: cancellation_service.message)
  end

  private

  def travel_package_params
    params.require(:travel_package).permit(:status)
  end

  def set_travel_package
    @travel_package = TravelPackage.find(params[:id])
  end
end