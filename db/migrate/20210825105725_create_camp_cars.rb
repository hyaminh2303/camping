class CreateCampCars < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_cars do |t|
      t.string :product_id
      t.string :name
      t.string :car_type
      t.references :category
      t.boolean :is_pick_up_and_drop_off_place_same, default: false
      t.integer :maximum_number_of_people
      t.boolean :is_public, default: false

      t.timestamps
    end
  end
end
