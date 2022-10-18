class CampCarSaleManagementService
  attr_accessor :camp_cars, :camp_car_receipts
  attr_reader :params

  def initialize(params={})
    @params = params
  end

  def run
    self.camp_cars = CampCar.all
    self.camp_cars = self.camp_cars.by_start_date_and_end_date(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present? # filter by date range

    self.camp_car_receipts = self.camp_cars.map do |camp_car|
      camp_car_bookings = CampCarBooking.by_camp_cars(camp_car.id)
      total_price = TravelPackage.by_ids(camp_car_bookings.pluck(:travel_package_id)).sum(:total_price)

      Hashit.new({ # covert hash to object
        camp_car_name: camp_car.name,
        number_of_bookings: camp_car_bookings.count,
        total_price: total_price,
        total_sale: total_price - (total_price * (AppSetting.instance.camp_car_commission_percentage / 100))
      })
    end

    self
  end
end
