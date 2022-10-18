class AddKeepPrivateToCampsites < ActiveRecord::Migration[6.1]
  def change
    add_column :campsites, :keep_private, :boolean, default: false
  end
end
