class CreateContactUs < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_us do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.text :details_of_inquiry

      t.timestamps
    end
  end
end
