class ChangeBirthdayToDateFields < ActiveRecord::Migration[6.1]
  def change
    remove_column :booking_contact_informations, :birthday, :string
    add_column :booking_contact_informations, :birthday, :date
  end
end
