class CreateCampCarOptionsCars < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_car_options_cars do |t|
      t.integer :camp_car_id
      t.integer :camp_car_option_id

      t.timestamps
    end
  end
end
