class AddWeightToStates < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :weight, :integer
  end
end
