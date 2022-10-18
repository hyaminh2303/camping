class AddDescriptionToCampCars < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_cars, :description, :text
  end
end
