class CreateBookingMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :booking_messages do |t|
      t.references :customer_user
      t.string :subject
      t.references :booking_messageable, polymorphic: true

      t.timestamps
    end
  end
end
