class AddWeightToCities < ActiveRecord::Migration[6.1]
  def change
    add_column :cities, :weight, :integer
  end
end
