class AddPostCodeToBookingContactInformations < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_contact_informations, :post_code, :string
  end
end
