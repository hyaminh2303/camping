module PaymentHelper
  def about_cancellation_path(travel_package)
    if travel_package.booking_type_campsite_booking?
      campsite_plan_path(travel_package.booking.campsite_plan)
    elsif travel_package.booking_type_camp_car_booking?
      # about car booking cancellation
    elsif travel_package.booking_type_camp_car_booking?
      # about tour booking cancellation
    end
  end
end
