class AddPostCodeToCampsites < ActiveRecord::Migration[6.1]
  def change
    add_column :campsites, :post_code, :integer
  end
end
