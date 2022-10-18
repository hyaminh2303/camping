class CreateSupplierContactInformations < ActiveRecord::Migration[6.1]
  def change
    create_table :supplier_contact_informations do |t|
      t.string :name_of_person_in_charge
      t.string :person_in_charge_name_kana
      t.string :phone_number
      t.string :fax
      t.string :email_address
      t.string :location
      t.string :accounting_personnel_information
      t.integer :supplier_company_id

      t.timestamps
    end
  end
end
