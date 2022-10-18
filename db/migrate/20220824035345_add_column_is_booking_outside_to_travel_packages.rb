class AddColumnIsBookingOutsideToTravelPackages < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_packages, :is_booking_outside, :boolean, default: false
  end
end
