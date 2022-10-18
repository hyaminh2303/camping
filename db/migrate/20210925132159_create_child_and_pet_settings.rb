class CreateChildAndPetSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :child_and_pet_settings do |t|
      t.integer :entity_type
      t.string :entity_label

      t.timestamps
    end
  end
end
