class AddCodeToPrefectures < ActiveRecord::Migration[6.1]
  def change
    add_column :prefectures, :code, :string
  end
end
