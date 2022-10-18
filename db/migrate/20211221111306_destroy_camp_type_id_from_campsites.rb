class DestroyCampTypeIdFromCampsites < ActiveRecord::Migration[6.1]
  def change
    remove_reference :campsites, :camp_type
  end
end
