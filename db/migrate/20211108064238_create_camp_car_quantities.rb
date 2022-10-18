class CreateCampCarQuantities < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_car_quantities do |t|
      t.date :date
      t.integer :quantity

      t.references :camp_car

      t.timestamps
    end
  end
end
