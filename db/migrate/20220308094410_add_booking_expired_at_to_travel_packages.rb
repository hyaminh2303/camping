class AddBookingExpiredAtToTravelPackages < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_packages, :booking_expired_at, :datetime
  end
end
