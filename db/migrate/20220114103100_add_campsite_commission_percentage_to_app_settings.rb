class AddCampsiteCommissionPercentageToAppSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :app_settings, :campsite_commission_percentage, :float, default: 10.5
  end
end
