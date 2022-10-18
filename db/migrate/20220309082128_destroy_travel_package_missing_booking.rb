class DestroyTravelPackageMissingBooking < ActiveRecord::Migration[6.1]
  def change
    travel_package_ids = TravelPackage.includes(:campsite_booking, :camp_car_booking).
                          select{|x| x.booking.blank?}.map(&:id)

    TravelPackage.where(id: travel_package_ids).destroy_all
  end
end
