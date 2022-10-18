class AddQuantityToCampCar < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_cars, :quantity, :integer
  end
end
