class AddCampTypeIdToCampsites < ActiveRecord::Migration[6.1]
  def change
    add_reference :campsites, :camp_type
  end
end
