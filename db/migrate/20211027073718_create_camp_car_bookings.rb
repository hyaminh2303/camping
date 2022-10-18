class CreateCampCarBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_car_bookings do |t|
      t.datetime :start_date_of_renting
      t.datetime :end_date_of_renting

      t.references :camp_car
      t.references :travel_package

      t.timestamps
    end
  end
end
