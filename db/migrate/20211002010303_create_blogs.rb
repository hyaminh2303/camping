class CreateBlogs < ActiveRecord::Migration[6.1]
  def change
    create_table :blogs do |t|
      t.string :title
      t.integer :blog_category_id
      t.text :description
      t.boolean :publish, default: false

      t.timestamps
    end
  end
end
