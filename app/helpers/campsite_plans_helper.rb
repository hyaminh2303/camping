module CampsitePlansHelper
  def get_campsite_plan_price(campsite_plan)
    total_price = CampsiteBookingService.new(CustomerUser.new, {id: campsite_plan.id}).init_travel_package.total_price

    gcamp_round_price(total_price)
  end
end
