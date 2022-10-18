class ChangePriceToIntegerOnCampCarOptions < ActiveRecord::Migration[6.1]
  def self.up
    change_column :camp_car_options, :fee_per_day, :integer
  end

  def self.down
    change_column :camp_car_options, :fee_per_day, :decimal
  end
end
