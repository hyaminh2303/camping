class RenameCampsitePlanFeeIdToNormalCampsitePlanFeeId < ActiveRecord::Migration[6.1]
  def change
    rename_column :campsite_plan_fee_details, :campsite_plan_fee_id, :normal_campsite_plan_fee_id
  end
end
