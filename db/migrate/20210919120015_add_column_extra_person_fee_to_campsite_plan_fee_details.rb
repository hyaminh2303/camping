class AddColumnExtraPersonFeeToCampsitePlanFeeDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :campsite_plan_fee_details, :extra_person_fee, :decimal
    add_column :campsite_plan_fee_details, :classification_day_setting_id, :integer
  end
end
