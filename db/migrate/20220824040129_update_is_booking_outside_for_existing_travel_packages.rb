class UpdateIsBookingOutsideForExistingTravelPackages < ActiveRecord::Migration[6.1]
  def change
    TravelPackage.by_admin.each do |travel_package|
      travel_package.update(is_booking_outside: true)
    end
  end
end
