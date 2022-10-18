class ChangePriceToIntegerOnChildAndPetIncludedInBookings < ActiveRecord::Migration[6.1]
  def self.up
    change_column :child_and_pet_included_in_bookings, :fee, :integer, default: 0
  end

  def self.down
    change_column :child_and_pet_included_in_bookings, :fee, :decimal, default: 0.0
  end
end
