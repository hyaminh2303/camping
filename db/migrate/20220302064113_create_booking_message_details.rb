class CreateBookingMessageDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :booking_message_details do |t|
      t.references :booking_message
      t.references :owner, polymorphic: true
      t.text :message

      t.timestamps
    end
  end
end
