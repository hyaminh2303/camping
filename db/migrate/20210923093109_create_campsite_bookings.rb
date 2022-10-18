class CreateCampsiteBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_bookings do |t|
      t.integer :number_of_adult
      t.datetime :check_in
      t.datetime :check_out

      t.references :travel_package
      t.references :campsite_plan

      t.timestamps
    end
  end
end
