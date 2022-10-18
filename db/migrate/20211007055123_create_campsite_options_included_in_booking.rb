class CreateCampsiteOptionsIncludedInBooking < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_options_included_in_booking do |t|
      t.string :name
      t.decimal :price
      t.integer :quantity, default: 0

      t.references :campsite_plan_option, index: false
      t.references :campsite_booking, index: false

      t.timestamps
    end
  end
end
