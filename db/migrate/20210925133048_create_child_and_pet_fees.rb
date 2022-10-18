class CreateChildAndPetFees < ActiveRecord::Migration[6.1]
  def change
    create_table :child_and_pet_fees do |t|
      t.references :normal_campsite_plan_fee
      t.references :classification_day_campsite_plan_fee, index: false
      t.references :classification_day_setting
      t.references :child_and_pet_setting
      t.decimal :fee_value, default: 0

      t.timestamps
    end
  end
end
