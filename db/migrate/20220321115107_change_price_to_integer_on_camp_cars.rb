class ChangePriceToIntegerOnCampCars < ActiveRecord::Migration[6.1]
  def self.up
    change_column :camp_cars, :fee_per_hour, :integer
    change_column :camp_cars, :fee_per_day, :integer
  end

  def self.down
    change_column :camp_cars, :fee_per_hour, :decimal
    change_column :camp_cars, :fee_per_day, :decimal
  end
end
