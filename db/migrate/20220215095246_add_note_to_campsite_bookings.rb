class AddNoteToCampsiteBookings < ActiveRecord::Migration[6.1]
  def change
    add_column :campsite_bookings, :note, :text
  end
end
