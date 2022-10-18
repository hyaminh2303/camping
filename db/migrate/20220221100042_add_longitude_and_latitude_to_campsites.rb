class AddLongitudeAndLatitudeToCampsites < ActiveRecord::Migration[6.1]
  def change
    add_column :campsites, :longitude, :float
    add_column :campsites, :latitude, :float
  end
end
