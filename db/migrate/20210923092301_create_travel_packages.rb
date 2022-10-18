class CreateTravelPackages < ActiveRecord::Migration[6.1]
  def change
    create_table :travel_packages do |t|
      t.string :status
      t.string :booking_type
      t.string :payment_method
      t.decimal :total_price

      t.references :customer_user

      t.timestamps
    end
  end
end
