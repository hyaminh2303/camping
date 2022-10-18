class ChangePriceToIntegerOnCampCarOptionsIncludedInBooking < ActiveRecord::Migration[6.1]
  def self.up
    change_column :camp_car_options_included_in_booking, :fee_per_day, :integer
  end

  def self.down
    change_column :camp_car_options_included_in_booking, :fee_per_day, :decimal
  end
end
