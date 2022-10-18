class AddWeightToCampCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_categories, :weight, :integer
  end
end
