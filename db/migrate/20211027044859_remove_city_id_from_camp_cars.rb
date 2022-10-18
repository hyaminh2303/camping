class RemoveCityIdFromCampCars < ActiveRecord::Migration[6.1]
  def change
    remove_column :camp_cars, :city_id, :integer
  end
end
