class AddCampCarCommissionPercentageToAppSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :app_settings, :camp_car_commission_percentage, :float, default: 23.5
  end
end
