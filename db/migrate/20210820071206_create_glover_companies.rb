class CreateGloverCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :glover_companies do |t|
      t.string :company_name
      t.string :location
      t.string :phone_number
      t.string :hp_url

      t.timestamps
    end
  end
end
