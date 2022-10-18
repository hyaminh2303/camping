class CreateCampsites < ActiveRecord::Migration[6.1]
  def change
    create_table :campsites do |t|
      t.string :unique_id
      t.string :name
      t.string :address
      t.string :contact_number

      t.references :state
      t.references :prefecture
      t.references :city

      t.timestamps
    end
  end
end
