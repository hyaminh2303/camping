class AddDayClassificationCampsitePlanFeeIdToCampsitePlanFeeDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :campsite_plan_fee_details, :classification_day_campsite_plan_fee_id, :integer
  end
end
