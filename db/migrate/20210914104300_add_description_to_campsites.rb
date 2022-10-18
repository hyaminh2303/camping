class AddDescriptionToCampsites < ActiveRecord::Migration[6.1]
  def change
    add_column :campsites, :description, :text
  end
end
