class CreateChildAndPetIncludedInBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :child_and_pet_included_in_bookings do |t|
      t.decimal :fee, default: 0
      t.references :campsite_booking, index: false
      t.string :entity_label
      t.string :entity_type
      t.references :child_and_pet_setting, index: false
      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end
