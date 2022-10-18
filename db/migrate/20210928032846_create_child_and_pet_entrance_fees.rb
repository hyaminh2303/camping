class CreateChildAndPetEntranceFees < ActiveRecord::Migration[6.1]
  def change
    create_table :child_and_pet_entrance_fees do |t|
      t.decimal :fee_value, default: 0
      t.references :campsite_entrance_fee
      t.references :child_and_pet_setting

      t.timestamps
    end
  end
end
