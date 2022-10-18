class CreateCampTypesCampsites < ActiveRecord::Migration[6.1]
  def change
    create_table :camp_types_campsites do |t|
      t.references :camp_type
      t.references :campsite

      t.timestamps
    end
  end
end
