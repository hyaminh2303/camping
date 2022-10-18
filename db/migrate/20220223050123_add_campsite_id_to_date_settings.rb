class AddCampsiteIdToDateSettings < ActiveRecord::Migration[6.1]
  def change
    add_reference :date_settings, :campsite
  end
end
