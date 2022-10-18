class CreateSliderBanners < ActiveRecord::Migration[6.1]
  def change
    create_table :slider_banners do |t|
      t.integer :page
      t.integer :position

      t.timestamps
    end
  end
end
