class ChangePriceToIntegerOnCampsitePlanFeeDetails < ActiveRecord::Migration[6.1]
  def self.up
    change_column :campsite_plan_fee_details, :basic_fee, :integer
    change_column :campsite_plan_fee_details, :extra_person_fee, :integer
  end

  def self.down
    change_column :campsite_plan_fee_details, :basic_fee, :decimal
    change_column :campsite_plan_fee_details, :extra_person_fee, :decimal
  end
end
