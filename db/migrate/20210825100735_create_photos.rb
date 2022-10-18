class CreatePhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :photos do |t|
      t.string :image
      t.references :photoable, polymorphic: true

      t.timestamps
    end
  end
end
