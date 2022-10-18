class CreateSupplierCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :supplier_companies do |t|
      t.string :operation_classification
      t.string :corporate_category
      t.string :company_name
      t.string :corporate_name_kana
      t.string :phone_number
      t.string :fax
      t.string :location
      t.string :hp_url
      t.string :ryokan

      t.string :type

      t.timestamps
    end
  end
end
