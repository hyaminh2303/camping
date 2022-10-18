class AddCodeToCities < ActiveRecord::Migration[6.1]
  def change
    add_column :cities, :code, :string
  end
end
