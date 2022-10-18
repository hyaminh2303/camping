class ChangeIsIncludedEntranceFeeValueDefaultFromCampsitePlans < ActiveRecord::Migration[6.1]
  def change
    change_column_default :campsite_plans, :is_included_entrance_fee, from: false, to: true
  end
end
