class ChangePriceToIntegerOnAppSettings < ActiveRecord::Migration[6.1]
  def self.up
    change_column :app_settings, :publication_fee, :integer, default: 5000
  end

  def self.down
    change_column :app_settings, :publication_fee, :decimal, default: 5000.0
  end
end
