class AddContentBlogTypeToBlogs < ActiveRecord::Migration[6.1]
  def change
    add_column :blogs, :content, :text
    add_column :blogs, :blog_type, :string
    remove_column :blogs, :publish, :boolean
  end
end
