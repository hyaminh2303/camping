class ChangePostCodeToStringFields < ActiveRecord::Migration[6.1]
  def self.up
    change_column :campsites, :post_code, :string
  end

  def self.down
    change_column :campsites, :post_code, :integer, using: 'post_code::integer'
  end
end
