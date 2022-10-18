class AddWeightToBlogCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :blog_categories, :weight, :integer
  end
end
