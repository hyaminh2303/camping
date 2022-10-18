class AddBookedByToTravelPackages < ActiveRecord::Migration[6.1]
  def change
    add_reference :travel_packages, :booked_by, polymorphic: true
  end
end
