class AddBookingRefNumberToTravelPackages < ActiveRecord::Migration[6.1]
  def change
    add_column :travel_packages, :booking_ref_number, :string
  end
end
