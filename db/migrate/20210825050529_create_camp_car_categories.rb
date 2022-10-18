class CreateCampCarCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_car_categories do |t|
      t.string :model
      t.integer :seats
      t.references :pick_up_drop_off_place

      t.timestamps
    end
  end
end
