class CreateSupplierCorporateRepresentativeInformations < ActiveRecord::Migration[6.1]
  def change
    create_table :supplier_corporate_representative_informations do |t|
      t.string :name_of_representative
      t.string :name_of_representative_kana
      t.string :position
      t.string :email_address
      t.integer :supplier_company_id

      t.timestamps
    end
  end
end
