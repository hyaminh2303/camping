class AddStatePrefectureCityToCampCars < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_cars, :state_id, :integer
    add_column :camp_cars, :prefecture_id, :integer
    add_column :camp_cars, :city_id, :integer
  end
end
