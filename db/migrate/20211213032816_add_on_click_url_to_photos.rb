class AddOnClickUrlToPhotos < ActiveRecord::Migration[6.1]
  def change
    add_column :photos, :on_click_url, :string
  end
end
