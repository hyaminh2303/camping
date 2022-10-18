class AddPublishDateToBlogs < ActiveRecord::Migration[6.1]
  def change
    add_column :blogs, :publish_date, :date
  end
end
