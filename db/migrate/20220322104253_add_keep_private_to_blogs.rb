class AddKeepPrivateToBlogs < ActiveRecord::Migration[6.1]
  def change
    add_column :blogs, :keep_private, :boolean, default: false
  end
end
