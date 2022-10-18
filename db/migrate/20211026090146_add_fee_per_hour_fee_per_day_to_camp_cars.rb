class AddFeePerHourFeePerDayToCampCars < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_cars, :fee_per_hour, :decimal
    add_column :camp_cars, :fee_per_day, :decimal
  end
end
