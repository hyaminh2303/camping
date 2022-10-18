class CampCarBookingPriceCalculationService
  attr_reader :camp_car_booking

  def initialize(camp_car_booking)
    @camp_car_booking = camp_car_booking
  end

  def calculate
    total = 0
    total += total_price_per_day
    total += total_price_for_options_per_day

    total
  end

  private

  def total_price_per_day
    camp_car_booking.number_of_nights * camp_car_booking.camp_car.fee_per_day
  end

  def total_price_for_options_per_day
    camp_car_booking.camp_car_options_included_in_booking.map(&:total_fee_per_day).sum()
  end
end
