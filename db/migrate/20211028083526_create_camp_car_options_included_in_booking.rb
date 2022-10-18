class CreateCampCarOptionsIncludedInBooking < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_car_options_included_in_booking do |t|
      t.string :name
      t.decimal :fee_per_day
      t.integer :quantity, default: 0

      t.references :camp_car_option, index: false
      t.references :camp_car_booking, index: false

      t.timestamps
    end
  end
end
