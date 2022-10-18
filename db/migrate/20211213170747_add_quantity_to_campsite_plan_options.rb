class AddQuantityToCampsitePlanOptions < ActiveRecord::Migration[6.1]
  def change
    add_column :campsite_plan_options, :quantity, :integer, default: 0
  end
end
