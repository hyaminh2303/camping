class AddSubtitleToCampCars < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_cars, :subtitle, :text
  end
end
