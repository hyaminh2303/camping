class CreateAccountants < ActiveRecord::Migration[6.1]
  def change
    create_table :accountants do |t|
      t.string :name
      t.string :name_phonetic
      t.string :phone_number
      t.string :email
      t.references :supplier_company

      t.timestamps
    end
  end
end
