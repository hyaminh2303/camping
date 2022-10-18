class AddNumberOfMaleNumberOfFemaleToBookingContactInformations < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_contact_informations, :number_of_male, :integer
    add_column :booking_contact_informations, :number_of_female, :integer
  end
end
