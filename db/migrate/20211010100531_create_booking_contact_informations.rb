class CreateBookingContactInformations < ActiveRecord::Migration[6.1]
  def change
    create_table :booking_contact_informations do |t|
      t.string :email
      t.string :name
      t.string :post_code_prefix
      t.string :post_code_suffix
      t.string :address
      t.string :birthday
      t.string :phone_nunmber
      t.references :travel_package

      t.timestamps
    end
  end
end
