class UpdateCategoryTypeFromBlogCategories < ActiveRecord::Migration[6.1]
  def change
    BlogCategory.where(category_type: nil).update_all(category_type: :glover_blog)
  end
end
