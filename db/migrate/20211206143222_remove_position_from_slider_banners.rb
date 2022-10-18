class RemovePositionFromSliderBanners < ActiveRecord::Migration[6.1]
  def change
    remove_column :slider_banners, :position, :integer
  end
end
