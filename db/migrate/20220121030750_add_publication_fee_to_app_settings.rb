class AddPublicationFeeToAppSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :app_settings, :publication_fee, :decimal, default: 5000
  end
end
