class AddIsIncludedEntranceFeeToCampsitePlans < ActiveRecord::Migration[6.1]
  def change
    add_column :campsite_plans, :is_included_entrance_fee, :boolean, default: false
  end
end
