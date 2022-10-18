class ChangePriceToIntegerOnCampsitePlanOptions < ActiveRecord::Migration[6.1]
  def self.up
    change_column :campsite_plan_options, :price, :integer
  end

  def self.down
    change_column :campsite_plan_options, :price, :decimal
  end
end
