class CreateCampsiteContentPhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :campsite_content_photos do |t|
      t.references :campsite

      t.timestamps
    end
  end
end
