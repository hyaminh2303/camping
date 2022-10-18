class AddQuantityToCampsitePlans < ActiveRecord::Migration[6.1]
  def change
    add_column :campsite_plans, :quantity, :integer
  end
end
