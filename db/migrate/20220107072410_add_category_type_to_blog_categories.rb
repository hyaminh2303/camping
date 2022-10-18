class AddCategoryTypeToBlogCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :blog_categories, :category_type, :string
  end
end
