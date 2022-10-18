class RemoveDayNamesAndPriorityFromCampsitePlanFees < ActiveRecord::Migration[6.1]
  def change
    remove_column :campsite_plan_fees, :priority
    remove_column :campsite_plan_fees, :day_names
  end
end
