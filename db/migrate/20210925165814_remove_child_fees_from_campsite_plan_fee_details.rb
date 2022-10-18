class RemoveChildFeesFromCampsitePlanFeeDetails < ActiveRecord::Migration[6.1]
  def change
    remove_column :campsite_plan_fee_details, :child_high_school_fee, :decimal
    remove_column :campsite_plan_fee_details, :child_primary_school_fee, :decimal
    remove_column :campsite_plan_fee_details, :child_under_five_years_old_fee, :decimal
    remove_column :campsite_plan_fee_details, :chile_junior_high_school_fee, :decimal
    remove_column :campsite_plan_fee_details, :pet_fee, :decimal
  end
end
