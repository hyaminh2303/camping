class ChangePriceToIntegerOnCampsitePlanDailyFeeSettings < ActiveRecord::Migration[6.1]
  def self.up
    change_column :campsite_plan_daily_fee_settings, :basic_fee, :integer
    change_column :campsite_plan_daily_fee_settings, :extra_person_fee, :integer
  end

  def self.down
    change_column :campsite_plan_daily_fee_settings, :basic_fee, :decimal
    change_column :campsite_plan_daily_fee_settings, :extra_person_fee, :decimal
  end
end
