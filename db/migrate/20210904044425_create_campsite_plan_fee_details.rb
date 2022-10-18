class CreateCampsitePlanFeeDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_plan_fee_details do |t|
      t.integer :campsite_plan_fee_id
      t.decimal :adult_fee
      t.decimal :child_high_school_fee
      t.decimal :chile_junior_high_school_fee
      t.decimal :child_primary_school_fee
      t.decimal :child_under_five_years_old_fee
      t.decimal :pet_fee
      t.integer :quantity

      t.timestamps
    end
  end
end
