class CreateCampCarOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_car_options do |t|
      t.string :name
      t.decimal :fee_per_day

      t.timestamps
    end
  end
end
