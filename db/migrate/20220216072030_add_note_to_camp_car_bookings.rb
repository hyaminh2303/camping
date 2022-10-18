class AddNoteToCampCarBookings < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_car_bookings, :note, :text
  end
end
