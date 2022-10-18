class AddWeightToCampCategoryGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :camp_category_groups, :weight, :integer
  end
end
