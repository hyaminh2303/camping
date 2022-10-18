class RenamePhoneNunmberInBookingContactInformations < ActiveRecord::Migration[6.1]
  def change
    rename_column :booking_contact_informations, :phone_nunmber, :phone_number
  end
end
