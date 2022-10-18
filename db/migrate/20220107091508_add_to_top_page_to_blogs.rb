class AddToTopPageToBlogs < ActiveRecord::Migration[6.1]
  def change
    add_column :blogs, :to_top_page, :boolean, default: false
  end
end
